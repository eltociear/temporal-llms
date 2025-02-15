#!/bin/bash

conda activate llama-hf

model_path="/PATH/TO/YOUR/LLAMA/MODEL"

# model_name="llama-7b"
# model_name="llama-13b"
# model_name="llama-33b"
# model_name="llama-65b"
# model_name="llama-7b-alpaca"
# model_name="Llama-2-7b-hf"
# model_name="Llama-2-13b-hf"
# model_name="Llama-2-70b-hf"
# model_name="Llama-2-7b-chat-hf"
# model_name="Llama-2-13b-chat-hf"
model_name="Llama-2-70b-chat-hf"

num_example=3

for prompt in 1 2 3
do
    # # ### run bi-tempqa with likelihood
    python3 tempeval-llama.py \
        --model_name $model_name \
        --model_path $model_path \
        --output_path llama-output/zs-bi-pt${prompt}-output-likelihood \
        --temperature 0 \
        --top_p 1.0 \
        --max_events_length 3800 \
        --max_new_decoding_tokens 0 \
        --bidirectional_temp_eval_likelihood \
        --prompt_template ${prompt} 
        
    # # ### run bi-tempqa with ICL + likelihood
    python3 tempeval-llama.py \
        --model_name $model_name \
        --model_path $model_path \
        --output_path llama-output/fs-bi-pt${prompt}-icl${num_example}-output-likelihood \
        --temperature 0 \
        --top_p 1.0 \
        --max_events_length 2400 \
        --max_new_decoding_tokens 0 \
        --bidirectional_temp_eval_likelihood \
        --do_in_context_learning \
        --prompt_template ${prompt} \
        --num_example ${num_example}

    # # ### run bi-tempqa with decoding
    python3 tempeval-llama.py \
        --model_name $model_name \
        --model_path $model_path \
        --output_path llama-output/zs-bi-pt${prompt}-output-decoding \
        --temperature 0 \
        --top_p 1.0 \
        --max_events_length 3800 \
        --max_new_decoding_tokens 1 \
        --bidirectional_temp_eval_decoding \
        --prompt_template ${prompt}
        
    # # ### run bi-tempqa with ICL + decoding
    python3 tempeval-llama.py \
        --model_name $model_name \
        --model_path $model_path \
        --output_path llama-output/fs-bi-pt${prompt}-icl${num_example}-truncation-output-decoding-del \
        --temperature 0 \
        --top_p 1.0 \
        --max_events_length 2600 \
        --max_new_decoding_tokens 1 \
        --bidirectional_temp_eval_decoding \
        --do_in_context_learning \
        --prompt_template ${prompt} \
        --num_example ${num_example}

    # # ### run bi-tempqa with ICL + CoT + decoding
    python3 tempeval-llama.py \
        --model_name $model_name \
        --model_path $model_path \
        --output_path llama-output/fs-bi-pt${prompt}-icl${num_example}-cot-truncation-output-decoding-del \
        --temperature 0.8 \
        --top_p 0.95 \
        --do_sample \
        --max_events_length 2600 \
        --max_new_decoding_tokens 128 \
        --bidirectional_temp_eval_decoding \
        --do_in_context_learning \
        --do_chain_of_thought \
        --prompt_template ${prompt} \
        --num_example ${num_example}
done