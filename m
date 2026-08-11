Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF872EB5A6
	for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 21:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786485148; cv=none; b=fLKUSut2Ij3TKiCFdGMQ2TLzcLEUzEVnK1uo+Jcx5M3PH+0soHEe/d7U8+ACr1HJ46mrsl4eK0lWABLtl+Ra/C0cXiiqRlsq/kcxcb77uBV6M+9+U6ZZ34TUF/AQkD5PiWxHB5XxTCc+jf91lmTcUJ69B2UMPGDhndz9KA7xzLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786485148; c=relaxed/simple;
	bh=2qE9SBr+YU/NVXzKErntsrM611wXgCMJntwU4aCiZ9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WnxXWjbF1jkNsoAIBQkSB6b2y4LdMV0CHPJhnNoCQM0PZsmUgCVd185ll0sZ4yJce7SVQzhn44wqPEEG/51tMbMSFtrcwqq8dP3pSoAcCkiT10tgi0+T9zQRXgL67fO123/AAjpI8XPfNvZnrJofucdFjrhIiMBQN3DGuCS2Nt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s1S87tuP; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s1S87tuP"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4996f1ee4a4so1285635e9.2
        for <cgroups@vger.kernel.org>; Tue, 11 Aug 2026 14:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786485144; x=1787089944; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cO/QN6+P0rr7qVL0NUwrQFJNJtRB0sM12Pld8uxMkv0=;
        b=s1S87tuPHK+RPpwxdHf9OXn2TZRq9+pHp2h9/ijFZrLEEBsxuoj0dR9Ho1RSdBds4v
         9yzt+nwoCgVf/d7ofa1b0bvBo+q9a1W21QV90PfgKL9/KVkA1tFq2dUgo1v+WA9tfv00
         EE3GmDAtA9bp3wKj6ptGqx2Hn4wYDDfTaAtdXVQ9lQbc70RpfGEDxzpcr/mu3aJzDgUE
         oACEikY+OsBD2fdg3l20lx7BqZtiVVlVLh2CsJSIU53ZtR2E9sKmTa0DfnNA7IG3w0I0
         U1i2e5nJFu0VnOhk/gWCvRHL3+CnW5Kcl3Qg2vJLkRmoPjqkCQi/gD0SnYb/XFqr092w
         OHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786485144; x=1787089944;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cO/QN6+P0rr7qVL0NUwrQFJNJtRB0sM12Pld8uxMkv0=;
        b=ImwkGzVIA5OqFD+mgzA0G6QoZ+zYk7RgvgXkkjVFHl+i4V5pcpVHz+ofsyJibOc4qa
         zuGQCxkKlmNVfiALAY2GdEF+di1w4746Hem22YSLBmkS4nZGYYUU88FE9IxH+wniGUTX
         87d4gqMMVxKS0esA398s93Ax2kUe2x9UWG5Odk57Jbw76bnRdmtHecr/IKi7dWCtlcyw
         UZQhyercE/Q2ZjH2MscFTCNorIPrZA4SjPYJlF663qi14ahCgxMazYG2cWpbttHGzi4K
         AK5zgo7THj0Z8loCWshlzULkOdflVrXunZuuBnnLt3HWh3IVXKuOpcg/ZZSSiteb0exl
         z62A==
X-Forwarded-Encrypted: i=1; AHgh+RrWiFYculreD5v9Ri/oECSnqxbe2nrKfQk8Jd6mklwgkBX70Wng1tjcpwkAKg84PWCzpyWDH95P@vger.kernel.org
X-Gm-Message-State: AOJu0YwHSOS81dXu6vU9gJsZlJGDfP7g2bzUOurer6UzlftwCw/Wk+px
	hmJE492yDdCu+m13TDzdeFuDv/4Hhvkip/wSospNqKGSnG5eBUgwRJi4
X-Gm-Gg: AR+sD127srFnUEt+ZmMiIyi6sCfbtUhdl22X3Op0oOO8Q7na+4czxQvPlDc1sNirKGR
	XotxCDQisPfHvvQlANCBNL96fK36M3tsZKBWBFAOXE3m2fmMyq0oYzyDakuZtwqhKcLPu7Rb7rA
	pdU9fuT4wnUyhub4jALg9JZfj60zn28f2QxhQvQOK8dfXOtkhQF7Ppep14igp69adZK0eN7qb93
	474BzNT+2g3vrmopSO41FvpWmtqXuhad95SjSDkjdtJdy6N/2yhgCUD4fvc2eqT9bdcWhIrPskY
	qFp2YaT4Br+uMsZubR7JLn8alwpF5sD831UUebgiG9Ba1djUKtMVIquN5u6yZST1UdSog88LfEA
	3QpHl6r8Il8SnBR/ZGKmHp9LcEv0rteZv3J6gMLx1Y5u9V5rTPi67GJRcBBwimt4ZI6SsRxC+Kj
	J6ijwAVevdarvLi9EdlvoJUxd4hjpukT+DB600ofitfeYJ6hbvo32dyj9nSrdAcQiGtsOVITw0D
	APhayFOoQfxPZivRv2PdDyUmuvkIah0zDBsc799wBXzWwb5
X-Received: by 2002:a7b:c7d1:0:b0:493:c634:952 with SMTP id 5b1f17b1804b1-4997c1192c0mr2281545e9.7.1786485143366;
        Tue, 11 Aug 2026 14:52:23 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd1f:f500:f867:fc8a:5174:5755? ([2a01:4b00:bd1f:f500:f867:fc8a:5174:5755])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997aaa7aabsm21966655e9.7.2026.08.11.14.52.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 14:52:22 -0700 (PDT)
Message-ID: <4a011b5f-7f84-40dc-a409-39f11326910c@gmail.com>
Date: Tue, 11 Aug 2026 22:52:20 +0100
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 2/4] bpf: add bpf_thread_wq kthread-backed
 workqueue with cgroup placement
To: Hui Zhu <hui.zhu@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, KP Singh <kpsingh@kernel.org>,
 Tao Chen <chen.dylane@linux.dev>, Mykyta Yatsenko <yatsenko@meta.com>,
 Leon Hwang <leon.hwang@linux.dev>,
 Anton Protopopov <a.s.protopopov@gmail.com>, Amery Hung
 <ameryhung@gmail.com>, Tobias Klauser <tklauser@distanz.ch>,
 Eyal Birger <eyal.birger@gmail.com>, Rong Tao <rongtao@cestc.cn>,
 Hao Luo <haoluo@google.com>, Peter Zijlstra <peterz@infradead.org>,
 Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>,
 Jeff Xu <jeffxu@chromium.org>, mkoutny@suse.com,
 Jan Hendrik Farr <kernel@jfarr.cc>, Christian Brauner <brauner@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Brian Gerst <brgerst@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>, Willem de Bruijn
 <willemb@google.com>, Jason Xing <kerneljasonxing@gmail.com>,
 Paul Chaignon <paul.chaignon@gmail.com>, Lance Yang <lance.yang@linux.dev>,
 Jiayuan Chen <jiayuan.chen@linux.dev>, Emil Tsalapatis
 <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1786086076.git.zhuhui@kylinos.cn>
 <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: Mykyta Yatsenko <mykyta.yatsenko5@gmail.com>
In-Reply-To: <cfb06f2626062fa60efbbd9d34089819b1a34522.1786086076.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/7/26 8:01 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Introduce bpf_thread_wq, a new BPF embedded map field similar to
> bpf_wq but backed by a dedicated kthread_worker instead of a system
> workqueue. The worker kthread can be attached to a specific cgroup at
> init time so BPF-deferred callbacks run under the resource limits of
> the target cgroup.
> 
> Three kfuncs are exposed:
>   bpf_thread_wq_init(twq, map, cgroup_id, flags)   [KF_SLEEPABLE]
>   bpf_thread_wq_set_callback(twq, cb, flags, aux)
>   bpf_thread_wq_start(twq, flags)
> 
> bpf_thread_wq_init() is registered only for BPF_PROG_TYPE_SYSCALL
> programs. It creates a kthread worker and may attach it to a cgroup;
> those paths can sleep and acquire kthread and cgroup locks. Restricting
> init to syscall programs prevents it from running in BPF contexts that
> may already hold locks which could deadlock with those paths.
> 
> bpf_thread_wq intentionally avoids the bpf_async infrastructure used by
> bpf_timer and bpf_wq. That infrastructure drives cleanup from irq_work
> in hardirq context, while bpf_thread_wq cancellation and final teardown
> may need to sleep through kthread_cancel_work_sync(),
> kthread_destroy_worker() and a final cgroup_put().
> bpf_thread_wq_cancel_and_free() therefore cancels work synchronously and
> drops the context reference; the last put waits for tasks-trace RCU
> readers and then schedules process-context work to run bpf_prog_put(),
> cgroup_put(), kthread_destroy_worker() and kfree().
> 
> Add BTF/map support for bpf_thread_wq fields, map teardown hooks,
> verifier handling for the callback kfunc, and cgroup_kthread_attach() to
> move the worker into the requested cgroup.
> 
> Supported map types are BPF_MAP_TYPE_HASH, BPF_MAP_TYPE_LRU_HASH, and
> BPF_MAP_TYPE_ARRAY, consistent with bpf_wq and bpf_task_work.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  include/linux/bpf.h                           |  15 +-
>  include/linux/cgroup.h                        |   2 +
>  include/uapi/linux/bpf.h                      |   4 +
>  kernel/bpf/btf.c                              |   7 +
>  kernel/bpf/helpers.c                          | 418 ++++++++++++++++++
>  kernel/bpf/syscall.c                          |  15 +-
>  kernel/bpf/verifier.c                         |  44 +-
>  kernel/cgroup/cgroup.c                        |  13 +
>  .../testing/selftests/bpf/bpf_experimental.h  |   7 +
>  9 files changed, 520 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 73bacfc6444d..d63ce8319869 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -213,6 +213,7 @@ enum btf_field_type {
>  	BPF_UPTR       = (1 << 11),
>  	BPF_RES_SPIN_LOCK = (1 << 12),
>  	BPF_TASK_WORK  = (1 << 13),
> +	BPF_THREAD_WQ  = (1 << 14),
>  };
>  
>  enum bpf_cgroup_storage_type {
> @@ -267,6 +268,7 @@ struct btf_record {
>  	int wq_off;
>  	int refcount_off;
>  	int task_work_off;
> +	int thread_wq_off;
>  	struct btf_field fields[];
>  };
>  
> @@ -372,6 +374,8 @@ static inline const char *btf_field_type_name(enum btf_field_type type)
>  		return "bpf_refcount";
>  	case BPF_TASK_WORK:
>  		return "bpf_task_work";
> +	case BPF_THREAD_WQ:
> +		return "bpf_thread_wq";
>  	default:
>  		WARN_ON_ONCE(1);
>  		return "unknown";
> @@ -412,6 +416,8 @@ static inline u32 btf_field_type_size(enum btf_field_type type)
>  		return sizeof(struct bpf_refcount);
>  	case BPF_TASK_WORK:
>  		return sizeof(struct bpf_task_work);
> +	case BPF_THREAD_WQ:
> +		return sizeof(struct bpf_thread_wq);
>  	default:
>  		WARN_ON_ONCE(1);
>  		return 0;
> @@ -446,6 +452,8 @@ static inline u32 btf_field_type_align(enum btf_field_type type)
>  		return __alignof__(struct bpf_refcount);
>  	case BPF_TASK_WORK:
>  		return __alignof__(struct bpf_task_work);
> +	case BPF_THREAD_WQ:
> +		return __alignof__(struct bpf_thread_wq);
>  	default:
>  		WARN_ON_ONCE(1);
>  		return 0;
> @@ -478,6 +486,7 @@ static inline void bpf_obj_init_field(const struct btf_field *field, void *addr)
>  	case BPF_KPTR_PERCPU:
>  	case BPF_UPTR:
>  	case BPF_TASK_WORK:
> +	case BPF_THREAD_WQ:
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);
> @@ -502,6 +511,7 @@ static inline bool btf_field_is_nmi_safe(enum btf_field_type type)
>  	case BPF_TASK_WORK:
>  	case BPF_KPTR_UNREF:
>  	case BPF_REFCOUNT:
> +	case BPF_THREAD_WQ:
>  		return true;
>  	default:
>  		return false;
> @@ -644,6 +654,7 @@ void copy_map_value_locked(struct bpf_map *map, void *dst, void *src,
>  void bpf_timer_cancel_and_free(void *timer);
>  void bpf_wq_cancel_and_free(void *timer);
>  void bpf_task_work_cancel_and_free(void *timer);
> +void bpf_thread_wq_cancel_and_free(void *val);
>  void bpf_list_head_free(const struct btf_field *field, void *list_head,
>  			struct bpf_spin_lock *spin_lock);
>  void bpf_rb_root_free(const struct btf_field *field, void *rb_root,
> @@ -701,7 +712,8 @@ bool bpf_map_meta_equal(const struct bpf_map *meta0,
>  
>  static inline bool bpf_map_has_internal_structs(struct bpf_map *map)
>  {
> -	return btf_record_has_field(map->record, BPF_TIMER | BPF_WORKQUEUE | BPF_TASK_WORK);
> +	return btf_record_has_field(map->record, BPF_TIMER | BPF_WORKQUEUE |
> +						 BPF_TASK_WORK | BPF_THREAD_WQ);
>  }
>  
>  void bpf_map_free_internal_structs(struct bpf_map *map, void *obj);
> @@ -2725,6 +2737,7 @@ bool btf_record_equal(const struct btf_record *rec_a, const struct btf_record *r
>  void bpf_obj_free_timer(const struct btf_record *rec, void *obj);
>  void bpf_obj_free_workqueue(const struct btf_record *rec, void *obj);
>  void bpf_obj_free_task_work(const struct btf_record *rec, void *obj);
> +void bpf_obj_free_thread_wq(const struct btf_record *rec, void *obj);
>  void bpf_obj_cancel_fields(struct bpf_map *map, void *obj);
>  void bpf_obj_free_fields(const struct btf_record *rec, void *obj);
>  void __bpf_obj_drop_impl(void *p, const struct btf_record *rec, bool percpu);
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index f2aa46a4f871..9b4a8dc748ac 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -923,4 +923,6 @@ struct cgroup *task_get_cgroup1(struct task_struct *tsk, int hierarchy_id);
>  
>  struct cgroup_of_peak *of_peak(struct kernfs_open_file *of);
>  
> +int cgroup_kthread_attach(struct cgroup *cgrp, struct task_struct *task);
> +
>  #endif /* _LINUX_CGROUP_H */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index ffd96e8b920b..0558520f67fe 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -7574,6 +7574,10 @@ struct bpf_wq {
>  	__u64 __opaque[2];
>  } __attribute__((aligned(8)));
>  
> +struct bpf_thread_wq {
> +	__u64 __opaque[2];
> +} __attribute__((aligned(8)));
> +
>  struct bpf_dynptr {
>  	__u64 __opaque[2];
>  } __attribute__((aligned(8)));
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 42414633cf26..bf6fb5f51d21 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3665,6 +3665,7 @@ static int btf_get_field_type(const struct btf *btf, const struct btf_type *var_
>  		{ BPF_TIMER, "bpf_timer", true },
>  		{ BPF_WORKQUEUE, "bpf_wq", true },
>  		{ BPF_TASK_WORK, "bpf_task_work", true },
> +		{ BPF_THREAD_WQ, "bpf_thread_wq", true },
>  		{ BPF_LIST_HEAD, "bpf_list_head", false },
>  		{ BPF_LIST_NODE, "bpf_list_node", false },
>  		{ BPF_RB_ROOT, "bpf_rb_root", false },
> @@ -3850,6 +3851,7 @@ static int btf_find_field_one(const struct btf *btf,
>  	case BPF_RB_NODE:
>  	case BPF_REFCOUNT:
>  	case BPF_TASK_WORK:
> +	case BPF_THREAD_WQ:
>  		ret = btf_find_struct(btf, var_type, off, sz, field_type,
>  				      info_cnt ? &info[0] : &tmp);
>  		if (ret < 0)
> @@ -4145,6 +4147,7 @@ struct btf_record *btf_parse_fields(const struct btf *btf, const struct btf_type
>  	rec->wq_off = -EINVAL;
>  	rec->refcount_off = -EINVAL;
>  	rec->task_work_off = -EINVAL;
> +	rec->thread_wq_off = -EINVAL;
>  	for (i = 0; i < cnt; i++) {
>  		field_type_size = btf_field_type_size(info_arr[i].type);
>  		if (info_arr[i].off + field_type_size > value_size) {
> @@ -4188,6 +4191,10 @@ struct btf_record *btf_parse_fields(const struct btf *btf, const struct btf_type
>  			WARN_ON_ONCE(rec->task_work_off >= 0);
>  			rec->task_work_off = rec->fields[i].offset;
>  			break;
> +		case BPF_THREAD_WQ:
> +			WARN_ON_ONCE(rec->thread_wq_off >= 0);
> +			rec->thread_wq_off = rec->fields[i].offset;
> +			break;
>  		case BPF_REFCOUNT:
>  			WARN_ON_ONCE(rec->refcount_off >= 0);
>  			/* Cache offset for faster lookup at runtime */
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 4709a5ad0474..68e7456f0649 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -29,6 +29,8 @@
>  #include <linux/task_work.h>
>  #include <linux/irq_work.h>
>  #include <linux/buildid.h>
> +#include <linux/kthread.h>
> +#include <linux/jhash.h>
>  
>  #include "../../lib/kstrtox.h"
>  
> @@ -1110,6 +1112,17 @@ static void *map_key_from_value(struct bpf_map *map, void *value, u32 *arr_idx)
>  	return (void *)value - round_up(map->key_size, 8);
>  }
>  
> +static u32 bpf_map_elem_id_from_value(struct bpf_map *map, void *value)
> +{
> +	u32 arr_idx;
> +	void *key;
> +
> +	key = map_key_from_value(map, value, &arr_idx);
> +	if (map->map_type == BPF_MAP_TYPE_ARRAY)
> +		return arr_idx;
> +	return jhash(key, map->key_size, 0);
> +}
> +
>  enum bpf_async_type {
>  	BPF_ASYNC_TYPE_TIMER = 0,
>  	BPF_ASYNC_TYPE_WQ,
> @@ -4769,6 +4782,397 @@ __bpf_kfunc int bpf_timer_cancel_async(struct bpf_timer *timer)
>  	}
>  }
>  
> +/*
> + * BPF thread workqueue (kthread_worker based) implementation
> + *
> + * Why bpf_thread_wq does NOT use the bpf_async infrastructure:

If the existing bpf_async infrastructure does not work for bpf_thread_wq,
does it make sense to keep using the same API: init, set_callback, start?
Maybe a single kfunc that does init->set_callback->start, similarly to 
what we do in task work (bpf_task_work_schedule()) will fit better?

> + *
> + * bpf_timer and bpf_wq share a common cleanup path via bpf_async:
> + *
> + *   bpf_async_cancel_and_free()
> + *     -> bpf_async_schedule_op()
> + *       -> irq_work_queue()                // schedule from any context
> + *         -> bpf_async_process_op()        // runs in hardirq context
> + *           -> bpf_wq_work() / timer cb    // atomic, non-sleepable
> + *
> + * This works for timer and workqueue because their callbacks and
> + * cancellation (hrtimer_cancel / bpf_wq_cancel_and_free) complete
> + * synchronously and need not sleep.  The hardirq context is sufficient.
> + *
> + * bpf_thread_wq is different: cancellation and final cleanup may need to
> + * sleep:

Sashiko already commented on this, if final cleanup needs to sleep, 
we can't do it in cancel_and_free(), because that can be called from
any context. That's why other special fields cancel_and_free() defer
to irq_work.

> + *
> + *   kthread_cancel_work_sync()    - waits for the work to finish, can
> + *                                    schedule out if the work is running.
> + *   kthread_destroy_worker()      - stops the kthread, internally
> + *                                    synchronizes with kthread exit.
> + *   cgroup_put() (final put)      - may acquire cgroup_mutex and other
> + *                                    sleeping locks during offline.
> + *
> + * None of these can be called from hardirq context (irq_work). Doing so
> + * would trigger might_sleep() warnings or deadlock.
> + *
> + * Therefore bpf_thread_wq implements its own RCU-based cleanup:
> + *
> + *   bpf_thread_wq_cancel_and_free()        // sleepable (called from
> + *                                          // map free / elem delete)
> + *     -> xchg(ctx, NULL)                   // detach atomically
> + *     -> kthread_cancel_work_sync()        // ok to sleep
> + *     -> bpf_thread_wq_ctx_put()
> + *       -> call_rcu_tasks_trace()          // wait for BPF callbacks
> + *         -> schedule_work()               // switch to sleepable context
> + *           -> bpf_thread_wq_destroy_work_fn()
> + *             -> bpf_prog_put()
> + *             -> cgroup_put()
> + *             -> kthread_destroy_worker()
> + *             -> kfree(ctx)
> + *
> + * The same design choice was made for bpf_task_work, which also avoids
> + * bpf_async because task_work cancellation synchronizes with the task
> + * and may sleep.
> + */
> +
> +struct bpf_thread_wq_ctx {
> +	struct kthread_worker *worker;
> +	struct kthread_work work;
> +	struct bpf_prog *prog;
> +	bpf_callback_t callback_fn;
> +	struct bpf_map *map;
> +	void *value;
> +	struct cgroup *cgrp;
> +	refcount_t refcnt;
> +	struct rcu_head rcu;
> +	struct work_struct destroy_work;
> +};
> +
> +/* Kernel-internal representation that fits in struct bpf_thread_wq */
> +struct bpf_thread_wq_kern {
> +	struct bpf_thread_wq_ctx *ctx;
> +} __aligned(8);
> +
> +static void bpf_thread_wq_destroy_work_fn(struct work_struct *work)
> +{
> +	struct bpf_thread_wq_ctx *ctx = container_of(work,
> +						     struct bpf_thread_wq_ctx,
> +						     destroy_work);
> +
> +	if (ctx->prog)
> +		bpf_prog_put(ctx->prog);
> +	if (ctx->cgrp)
> +		cgroup_put(ctx->cgrp);
> +	if (ctx->worker)
> +		kthread_destroy_worker(ctx->worker);
> +	kfree(ctx);
> +}
> +
> +static void bpf_thread_wq_ctx_free_rcu(struct rcu_head *rcu)
> +{
> +	struct bpf_thread_wq_ctx *ctx = container_of(rcu,
> +						     struct bpf_thread_wq_ctx,
> +						     rcu);
> +
> +	INIT_WORK(&ctx->destroy_work, bpf_thread_wq_destroy_work_fn);
> +	schedule_work(&ctx->destroy_work);
> +}
> +
> +static void bpf_thread_wq_ctx_put(struct bpf_thread_wq_ctx *ctx)
> +{
> +	if (!refcount_dec_and_test(&ctx->refcnt))
> +		return;
> +	call_rcu_tasks_trace(&ctx->rcu, bpf_thread_wq_ctx_free_rcu);
> +}
> +
> +static void bpf_thread_wq_work_fn(struct kthread_work *work)
> +{
> +	struct bpf_thread_wq_ctx *ctx = container_of(work,
> +						     struct bpf_thread_wq_ctx,
> +						     work);
> +	bpf_callback_t callback_fn;
> +	void *value = ctx->value;
> +	struct bpf_map *map = ctx->map;
> +	void *key;
> +	u32 idx;
> +
> +	BTF_TYPE_EMIT(struct bpf_thread_wq);
> +
> +	callback_fn = READ_ONCE(ctx->callback_fn);
> +	if (!callback_fn)
> +		goto out;
> +	key = map_key_from_value(map, value, &idx);
> +
> +	rcu_read_lock_trace();
> +	migrate_disable();
> +
> +	callback_fn = READ_ONCE(ctx->callback_fn);
> +	if (callback_fn)
> +		callback_fn((u64)(long)map, (u64)(long)key, (u64)(long)value,
> +			    0, 0);
> +
> +	migrate_enable();
> +	rcu_read_unlock_trace();
> +
> +out:
> +	bpf_thread_wq_ctx_put(ctx);
> +}
> +
> +/*
> + * bpf_thread_wq_init() creates a kthread worker and may attach it to a cgroup.
> + * The helpers used here can sleep and acquire several locks through kthread
> + * creation/destruction, cgroup lookup and cgroup kthread attachment. Keep this
> + * kfunc available only to BPF_PROG_TYPE_SYSCALL programs so it is not invoked
> + * from BPF program contexts that already hold locks which could deadlock with
> + * those paths.
> + */
> +__bpf_kfunc int bpf_thread_wq_init(struct bpf_thread_wq *twq, void *p__map,
> +				   u64 cgroup_id, unsigned int flags)
> +{
> +	struct bpf_thread_wq_kern *twk = (struct bpf_thread_wq_kern *)twq;
> +	struct bpf_map *map = p__map;
> +	struct bpf_thread_wq_ctx *ctx, *old_ctx;
> +	struct kthread_worker *worker;
> +	struct cgroup *cgrp = NULL;
> +	void *value;
> +	u32 elem_id;
> +	int err;
> +
> +	BUILD_BUG_ON(sizeof(struct bpf_thread_wq_kern)
> +			> sizeof(struct bpf_thread_wq));
> +	BUILD_BUG_ON(__alignof__(struct bpf_thread_wq_kern)
> +			!= __alignof__(struct bpf_thread_wq));
> +
> +	if (flags)
> +		return -EINVAL;
> +
> +	old_ctx = READ_ONCE(twk->ctx);
> +	if (old_ctx)
> +		return -EBUSY;
> +
> +	value = (void *)twq - map->record->thread_wq_off;
> +	elem_id = bpf_map_elem_id_from_value(map, value);
> +	worker = kthread_run_worker(0, "bpf_twq/%d/%x", map->id, elem_id);
> +	if (IS_ERR(worker))
> +		return PTR_ERR(worker);
> +
> +	/* Setup ctx. */
> +	ctx = bpf_map_kmalloc_nolock(map, sizeof(*ctx), GFP_KERNEL,
> +				     map->numa_node);
> +	if (!ctx) {
> +		err = -ENOMEM;
> +		goto destroy_worker;
> +	}
> +	memset(ctx, 0, sizeof(*ctx));
> +	ctx->worker = worker;
> +	ctx->map = map;
> +	ctx->value = value;
> +	refcount_set(&ctx->refcnt, 1);
> +	kthread_init_work(&ctx->work, bpf_thread_wq_work_fn);
> +
> +	if (cgroup_id) {
> +#ifdef CONFIG_CGROUPS
> +		cgrp = cgroup_get_from_id(cgroup_id);
> +		if (IS_ERR(cgrp)) {
> +			err = PTR_ERR(cgrp);
> +			goto kfree_ctx;
> +		}
> +		ctx->cgrp = cgrp;
> +
> +		/*
> +		 * kthread_run_worker() wakes the kthread, but it may not have
> +		 * executed cgroup_kthread_ready() yet, which clears
> +		 * no_cgroup_migration.
> +		 * Do a queue work and flush to wait the kthread run.
> +		 */
> +		refcount_inc(&ctx->refcnt);
> +		if (!kthread_queue_work(ctx->worker, &ctx->work)) {
> +			refcount_dec(&ctx->refcnt);
> +			err = -EBUSY;
> +			goto cgroup_put;
> +		}
> +		kthread_flush_work(&ctx->work);
> +
> +		if (worker->task->no_cgroup_migration) {
> +			err = -EAGAIN;
> +			goto cgroup_put;
> +		}
> +
> +		err = cgroup_kthread_attach(cgrp, worker->task);
> +		if (err)
> +			goto cgroup_put;
> +#else
> +		err = -EOPNOTSUPP;
> +		goto kfree_ctx;
> +#endif
> +	}
> +
> +	old_ctx = cmpxchg(&twk->ctx, NULL, ctx);
> +	if (old_ctx) {
> +		err = -EBUSY;
> +		goto cgroup_put;
> +	}
> +
> +	/*
> +	 * Paired with the map destruction path.  Ensures that ctx is globally
> +	 * visible before we check map->usercnt.
> +	 * If usercnt has dropped to zero, the destruction path will either see
> +	 * the ctx (and cancel it) or we see usercnt == 0 here and cancel
> +	 * ourselves.
> +	 * Without this barrier, a CPU could reorder the load of usercnt before
> +	 * the cmpxchg store becomes visible, breaking the mutual exclusion
> +	 * guarantee.
> +	 */
> +	smp_mb();
> +
> +	if (!atomic64_read(&map->usercnt)) {
> +		bpf_thread_wq_cancel_and_free(twq);
> +		return -EPERM;
> +	}
> +
> +	return 0;
> +
> +cgroup_put:
> +#ifdef CONFIG_CGROUPS
> +	if (cgrp)
> +		cgroup_put(cgrp);
> +#endif
> +kfree_ctx:
> +	/*
> +	 * Not use bpf_thread_wq_ctx_put because ctx has not yet entered
> +	 * the running state.
> +	 */
> +	kfree(ctx);
> +destroy_worker:
> +	kthread_destroy_worker(worker);
> +	return err;
> +}
> +
> +__bpf_kfunc int bpf_thread_wq_set_callback(struct bpf_thread_wq *twq,
> +					   int (callback_fn)(void *map,
> +							     int *key,
> +							     void *value),
> +					   unsigned int flags,
> +					   struct bpf_prog_aux *aux)
> +{
> +	struct bpf_thread_wq_kern *twk = (struct bpf_thread_wq_kern *)twq;
> +	struct bpf_thread_wq_ctx *ctx;
> +	struct bpf_prog *prog;
> +
> +	if (flags)
> +		return -EINVAL;
> +
> +	ctx = READ_ONCE(twk->ctx);
> +	if (!ctx)
> +		return -EINVAL;
> +
> +	prog = bpf_prog_inc_not_zero(aux->prog);
> +	if (IS_ERR(prog))
> +		return PTR_ERR(prog);
> +
> +	/*
> +	 * Allow set_callback only once to prevent UAF: a concurrent
> +	 * set_callback could bpf_prog_put() the prog while the worker
> +	 * kthread is still executing its callback.
> +	 */
> +	if (cmpxchg(&ctx->prog, NULL, prog) != NULL) {
> +		bpf_prog_put(prog);
> +		return -EBUSY;
> +	}
> +	/*
> +	 * Safe to set callback_fn after prog: bpf_thread_wq_start() and
> +	 * bpf_thread_wq_work_fn() both check callback_fn with READ_ONCE()
> +	 * and bail out if it is still NULL.
> +	 */
> +	WRITE_ONCE(ctx->callback_fn, (void *)callback_fn);
> +
> +	return 0;
> +}
> +
> +__bpf_kfunc int
> +bpf_thread_wq_start(struct bpf_thread_wq *twq, unsigned int flags)
> +{
> +	struct bpf_thread_wq_kern *twk = (struct bpf_thread_wq_kern *)twq;
> +	struct bpf_thread_wq_ctx *ctx;
> +	int err;
> +
> +	if (flags)
> +		return -EINVAL;
> +
> +	rcu_read_lock_trace();
> +
> +	err = 0;
> +
> +	ctx = READ_ONCE(twk->ctx);
> +	if (!ctx || !READ_ONCE(ctx->callback_fn)) {
> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +
> +	if (!refcount_inc_not_zero(&ctx->refcnt))
> +		err = -ENOENT;
> +
> +unlock:
> +	rcu_read_unlock_trace();
> +	if (err)
> +		return err;
> +
> +	if (!kthread_queue_work(ctx->worker, &ctx->work)) {
> +		bpf_thread_wq_ctx_put(ctx);
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +void bpf_thread_wq_cancel_and_free(void *val)
> +{
> +	struct bpf_thread_wq_kern *twk = val;
> +	struct bpf_thread_wq_ctx *ctx;
> +
> +	ctx = xchg(&twk->ctx, NULL);
> +	if (!ctx)
> +		return;
> +
> +	might_sleep();
> +
> +	/*
> +	 * Prevent future callbacks from running and wait for any
> +	 * in-progress execution to finish.
> +	 */
> +	WRITE_ONCE(ctx->callback_fn, NULL);
> +	/*
> +	 * kthread_cancel_work_sync() returns true when it dequeues a pending
> +	 * work item from the work_list without executing it.  Each successful
> +	 * bpf_thread_wq_start() call increments ctx->refcnt and relies on the
> +	 * subsequent bpf_thread_wq_work_fn() execution to release that
> +	 * reference via bpf_thread_wq_ctx_put().  If the work was pending and
> +	 * got cancelled here, work_fn will never run for that queued instance,
> +	 * so we must drop the reference ourselves to avoid a permanent refcount
> +	 * leak.
> +	 *
> +	 * This covers two scenarios uniformly:
> +	 *  1. The work is purely pending (not currently executing) - e.g. a
> +	 *     normal bpf_thread_wq_start() call queued it but the worker
> +	 *     thread hasn't picked it up yet.
> +	 *  2. The work is currently in-flight AND was self-rescheduled from
> +	 *     within the callback - kthread_cancel_work_sync() dequeues the
> +	 *     re-queued pending node and then waits for the in-flight
> +	 *     execution to complete.
> +	 * In both cases the return value is true, indicating one orphaned
> +	 * reference that needs to be released here.
> +	 */
> +	if (kthread_cancel_work_sync(&ctx->work))
> +		bpf_thread_wq_ctx_put(ctx);
> +
> +	/*
> +	 * Drop our own reference.  If the work was still in-flight above,
> +	 * the refcount won't hit zero here - it will reach zero when the
> +	 * work path calls bpf_thread_wq_ctx_put() upon completion.  Either
> +	 * way, final cleanup (worker destruction, prog put, cgroup put,
> +	 * kfree) happens exclusively in the RCU callback to keep the
> +	 * teardown path single-threaded.
> +	 */
> +	bpf_thread_wq_ctx_put(ctx);
> +}
> +
>  __bpf_kfunc_end_defs();
>  
>  static void bpf_task_work_cancel_scheduled(struct irq_work *irq_work)
> @@ -4915,6 +5319,8 @@ BTF_ID_FLAGS(func, bpf_modify_return_test_tp)
>  BTF_ID_FLAGS(func, bpf_wq_init)
>  BTF_ID_FLAGS(func, bpf_wq_set_callback, KF_IMPLICIT_ARGS)
>  BTF_ID_FLAGS(func, bpf_wq_start)
> +BTF_ID_FLAGS(func, bpf_thread_wq_set_callback, KF_IMPLICIT_ARGS)
> +BTF_ID_FLAGS(func, bpf_thread_wq_start)
>  BTF_ID_FLAGS(func, bpf_preempt_disable)
>  BTF_ID_FLAGS(func, bpf_preempt_enable)
>  BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
> @@ -4976,6 +5382,15 @@ static const struct btf_kfunc_id_set common_kfunc_set = {
>  	.set   = &common_btf_ids,
>  };
>  
> +BTF_KFUNCS_START(syscall_btf_ids)
> +BTF_ID_FLAGS(func, bpf_thread_wq_init, KF_SLEEPABLE)
> +BTF_KFUNCS_END(syscall_btf_ids)
> +
> +static const struct btf_kfunc_id_set syscall_kfunc_set = {
> +	.owner = THIS_MODULE,
> +	.set   = &syscall_btf_ids,
> +};
> +
>  static int __init kfunc_init(void)
>  {
>  	int ret;
> @@ -4998,6 +5413,7 @@ static int __init kfunc_init(void)
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS, &generic_kfunc_set);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &generic_kfunc_set);
>  	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_CGROUP_SKB, &generic_kfunc_set);
> +	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &syscall_kfunc_set);
>  	ret = ret ?: register_btf_id_dtor_kfuncs(generic_dtors,
>  						  ARRAY_SIZE(generic_dtors),
>  						  THIS_MODULE);
> @@ -5035,4 +5451,6 @@ void bpf_map_free_internal_structs(struct bpf_map *map, void *val)
>  		bpf_obj_free_workqueue(map->record, val);
>  	if (btf_record_has_field(map->record, BPF_TASK_WORK))
>  		bpf_obj_free_task_work(map->record, val);
> +	if (btf_record_has_field(map->record, BPF_THREAD_WQ))
> +		bpf_obj_free_thread_wq(map->record, val);
>  }
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 8d111da88655..dea14823bacd 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -688,6 +688,7 @@ void btf_record_free(struct btf_record *rec)
>  		case BPF_REFCOUNT:
>  		case BPF_WORKQUEUE:
>  		case BPF_TASK_WORK:
> +		case BPF_THREAD_WQ:
>  			/* Nothing to release */
>  			break;
>  		default:
> @@ -742,6 +743,7 @@ struct btf_record *btf_record_dup(const struct btf_record *rec)
>  		case BPF_REFCOUNT:
>  		case BPF_WORKQUEUE:
>  		case BPF_TASK_WORK:
> +		case BPF_THREAD_WQ:
>  			/* Nothing to acquire */
>  			break;
>  		default:
> @@ -807,6 +809,13 @@ void bpf_obj_free_task_work(const struct btf_record *rec, void *obj)
>  	bpf_task_work_cancel_and_free(obj + rec->task_work_off);
>  }
>  
> +void bpf_obj_free_thread_wq(const struct btf_record *rec, void *obj)
> +{
> +	if (WARN_ON_ONCE(!btf_record_has_field(rec, BPF_THREAD_WQ)))
> +		return;
> +	bpf_thread_wq_cancel_and_free(obj + rec->thread_wq_off);
> +}
> +
>  void bpf_obj_cancel_fields(struct bpf_map *map, void *obj)
>  {
>  	bpf_map_free_internal_structs(map, obj);
> @@ -839,6 +848,9 @@ void bpf_obj_free_fields(const struct btf_record *rec, void *obj)
>  		case BPF_TASK_WORK:
>  			bpf_task_work_cancel_and_free(field_ptr);
>  			break;
> +		case BPF_THREAD_WQ:
> +			bpf_thread_wq_cancel_and_free(field_ptr);
> +			break;
>  		case BPF_KPTR_UNREF:
>  			WRITE_ONCE(*(u64 *)field_ptr, 0);
>  			break;
> @@ -1265,7 +1277,7 @@ static int map_check_btf(struct bpf_map *map, struct bpf_token *token,
>  	map->record = btf_parse_fields(btf, value_type,
>  				       BPF_SPIN_LOCK | BPF_RES_SPIN_LOCK | BPF_TIMER | BPF_KPTR | BPF_LIST_HEAD |
>  				       BPF_RB_ROOT | BPF_REFCOUNT | BPF_WORKQUEUE | BPF_UPTR |
> -				       BPF_TASK_WORK,
> +				       BPF_TASK_WORK | BPF_THREAD_WQ,
>  				       map->value_size);
>  	if (!IS_ERR_OR_NULL(map->record)) {
>  		int i;
> @@ -1299,6 +1311,7 @@ static int map_check_btf(struct bpf_map *map, struct bpf_token *token,
>  			case BPF_TIMER:
>  			case BPF_WORKQUEUE:
>  			case BPF_TASK_WORK:
> +			case BPF_THREAD_WQ:
>  				if (map->map_type != BPF_MAP_TYPE_HASH &&
>  				    map->map_type != BPF_MAP_TYPE_RHASH &&
>  				    map->map_type != BPF_MAP_TYPE_LRU_HASH &&
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 7439afdc851a..4d713bb767e0 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -477,6 +477,7 @@ static bool is_async_callback_calling_kfunc(u32 btf_id);
>  static bool is_callback_calling_kfunc(u32 btf_id);
>  
>  static bool is_bpf_wq_set_callback_kfunc(u32 btf_id);
> +static bool is_bpf_thread_wq_set_callback_kfunc(u32 btf_id);
>  static bool is_task_work_add_kfunc(u32 func_id);
>  
>  static bool is_sync_callback_calling_function(enum bpf_func_id func_id)
> @@ -516,9 +517,11 @@ static bool is_async_cb_sleepable(struct bpf_verifier_env *env, struct bpf_insn
>  	if (bpf_helper_call(insn) && insn->imm == BPF_FUNC_timer_set_callback)
>  		return false;
>  
> -	/* bpf_wq and bpf_task_work callbacks are always sleepable. */
> +	/* bpf_wq, bpf_thread_wq and bpf_task_work callbacks are always sleepable. */
>  	if (bpf_pseudo_kfunc_call(insn) && insn->off == 0 &&
> -	    (is_bpf_wq_set_callback_kfunc(insn->imm) || is_task_work_add_kfunc(insn->imm)))
> +	    (is_bpf_wq_set_callback_kfunc(insn->imm) ||
> +	     is_bpf_thread_wq_set_callback_kfunc(insn->imm) ||
> +	     is_task_work_add_kfunc(insn->imm)))
>  		return true;
>  
>  	verifier_bug(env, "unhandled async callback in is_async_cb_sleepable");
> @@ -1871,7 +1874,10 @@ static void refine_map_lookup_value(struct bpf_reg_state *reg)
>  		 * as UID of the inner map.
>  		 */
>  		if (btf_record_has_field(map->inner_map_meta->record,
> -					 BPF_TIMER | BPF_WORKQUEUE | BPF_TASK_WORK))
> +					 BPF_TIMER |
> +					 BPF_WORKQUEUE |
> +					 BPF_TASK_WORK |
> +					 BPF_THREAD_WQ))
>  			reg->map_uid = reg->id;
>  	} else if (map->map_type == BPF_MAP_TYPE_XSKMAP) {
>  		reg->type = PTR_TO_XDP_SOCK | maybe_null;
> @@ -7243,6 +7249,9 @@ static int check_map_field_pointer(struct bpf_verifier_env *env, struct bpf_reg_
>  	case BPF_WORKQUEUE:
>  		field_off = map->record->wq_off;
>  		break;
> +	case BPF_THREAD_WQ:
> +		field_off = map->record->thread_wq_off;
> +		break;
>  	default:
>  		verifier_bug(env, "unsupported BTF field type: %s\n", struct_name);
>  		return -EINVAL;
> @@ -10940,6 +10949,7 @@ enum {
>  	KF_ARG_WORKQUEUE_ID,
>  	KF_ARG_RES_SPIN_LOCK_ID,
>  	KF_ARG_TASK_WORK_ID,
> +	KF_ARG_THREAD_WQ_ID,
>  	KF_ARG_PROG_AUX_ID,
>  	KF_ARG_TIMER_ID
>  };
> @@ -10953,6 +10963,7 @@ BTF_ID(struct, bpf_rb_node)
>  BTF_ID(struct, bpf_wq)
>  BTF_ID(struct, bpf_res_spin_lock)
>  BTF_ID(struct, bpf_task_work)
> +BTF_ID(struct, bpf_thread_wq)
>  BTF_ID(struct, bpf_prog_aux)
>  BTF_ID(struct, bpf_timer)
>  
> @@ -11013,6 +11024,11 @@ static bool is_kfunc_arg_task_work(const struct btf *btf, const struct btf_param
>  	return __is_kfunc_ptr_arg_type(btf, arg, KF_ARG_TASK_WORK_ID);
>  }
>  
> +static bool is_kfunc_arg_thread_wq(const struct btf *btf, const struct btf_param *arg)
> +{
> +	return __is_kfunc_ptr_arg_type(btf, arg, KF_ARG_THREAD_WQ_ID);
> +}
> +
>  static bool is_kfunc_arg_res_spin_lock(const struct btf *btf, const struct btf_param *arg)
>  {
>  	return __is_kfunc_ptr_arg_type(btf, arg, KF_ARG_RES_SPIN_LOCK_ID);
> @@ -11132,6 +11148,7 @@ enum kfunc_ptr_arg_type {
>  	KF_ARG_PTR_TO_IRQ_FLAG,
>  	KF_ARG_PTR_TO_RES_SPIN_LOCK,
>  	KF_ARG_PTR_TO_TASK_WORK,
> +	KF_ARG_PTR_TO_THREAD_WQ,
>  };
>  
>  enum special_kfunc_type {
> @@ -11178,6 +11195,7 @@ enum special_kfunc_type {
>  	KF_bpf_percpu_obj_drop,
>  	KF_bpf_throw,
>  	KF_bpf_wq_set_callback,
> +	KF_bpf_thread_wq_set_callback,
>  	KF_bpf_preempt_disable,
>  	KF_bpf_preempt_enable,
>  	KF_bpf_iter_css_task_new,
> @@ -11258,6 +11276,7 @@ BTF_ID(func, bpf_percpu_obj_drop_impl)
>  BTF_ID(func, bpf_percpu_obj_drop)
>  BTF_ID(func, bpf_throw)
>  BTF_ID(func, bpf_wq_set_callback)
> +BTF_ID(func, bpf_thread_wq_set_callback)
>  BTF_ID(func, bpf_preempt_disable)
>  BTF_ID(func, bpf_preempt_enable)
>  #ifdef CONFIG_CGROUPS
> @@ -11460,6 +11479,8 @@ get_kfunc_arg_type(struct bpf_verifier_env *env, struct bpf_call_arg_meta *meta,
>  		arg_type = KF_ARG_PTR_TO_TIMER;
>  	else if (is_kfunc_arg_task_work(meta->btf, &args[arg]))
>  		arg_type = KF_ARG_PTR_TO_TASK_WORK;
> +	else if (is_kfunc_arg_thread_wq(meta->btf, &args[arg]))
> +		arg_type = KF_ARG_PTR_TO_THREAD_WQ;
>  	else if (is_kfunc_arg_irq_flag(meta->btf, &args[arg]))
>  		arg_type = KF_ARG_PTR_TO_IRQ_FLAG;
>  	else if (is_kfunc_arg_res_spin_lock(meta->btf, &args[arg]))
> @@ -11852,6 +11873,7 @@ static bool is_sync_callback_calling_kfunc(u32 btf_id)
>  static bool is_async_callback_calling_kfunc(u32 btf_id)
>  {
>  	return is_bpf_wq_set_callback_kfunc(btf_id) ||
> +	       is_bpf_thread_wq_set_callback_kfunc(btf_id) ||
>  	       is_task_work_add_kfunc(btf_id);
>  }
>  
> @@ -11866,6 +11888,11 @@ static bool is_bpf_wq_set_callback_kfunc(u32 btf_id)
>  	return btf_id == special_kfunc_list[KF_bpf_wq_set_callback];
>  }
>  
> +static bool is_bpf_thread_wq_set_callback_kfunc(u32 btf_id)
> +{
> +	return btf_id == special_kfunc_list[KF_bpf_thread_wq_set_callback];
> +}
> +
>  static bool is_callback_calling_kfunc(u32 btf_id)
>  {
>  	return is_sync_callback_calling_kfunc(btf_id) ||
> @@ -12211,6 +12238,7 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_call_arg_me
>  		case KF_ARG_PTR_TO_WORKQUEUE:
>  		case KF_ARG_PTR_TO_TIMER:
>  		case KF_ARG_PTR_TO_TASK_WORK:
> +		case KF_ARG_PTR_TO_THREAD_WQ:
>  		case KF_ARG_PTR_TO_IRQ_FLAG:
>  		case KF_ARG_PTR_TO_RES_SPIN_LOCK:
>  			break;
> @@ -13158,6 +13186,16 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>  		}
>  	}
>  
> +	if (is_bpf_thread_wq_set_callback_kfunc(meta.func_id)) {
> +		err = push_callback_call(env, insn, insn_idx, meta.subprogno,
> +					 set_timer_callback_state);
> +		if (err) {
> +			verbose(env, "kfunc %s#%d failed callback verification\n",
> +				func_name, meta.func_id);
> +			return err;
> +		}
> +	}
> +
>  	if (is_task_work_add_kfunc(meta.func_id)) {
>  		err = push_callback_call(env, insn, insn_idx, meta.subprogno,
>  					 set_task_work_schedule_callback_state);
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 38f8d9df8fbc..164e069c7576 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -3042,6 +3042,19 @@ int cgroup_attach_task(struct cgroup *dst_cgrp, struct task_struct *leader,
>  	return ret;
>  }
>  
> +int cgroup_kthread_attach(struct cgroup *cgrp, struct task_struct *task)
> +{
> +	int ret;
> +
> +	cgroup_lock();
> +	cgroup_attach_lock(CGRP_ATTACH_LOCK_GLOBAL, NULL);
> +	ret = cgroup_attach_task(cgrp, task, false);
> +	cgroup_attach_unlock(CGRP_ATTACH_LOCK_GLOBAL, NULL);
> +	cgroup_unlock();
> +
> +	return ret;
> +}
> +
>  struct task_struct *cgroup_procs_write_start(char *buf, bool threadgroup,
>  					     enum cgroup_attach_lock_mode *lock_mode)
>  {
> diff --git a/tools/testing/selftests/bpf/bpf_experimental.h b/tools/testing/selftests/bpf/bpf_experimental.h
> index ff37ae5a113d..ea905ea5603c 100644
> --- a/tools/testing/selftests/bpf/bpf_experimental.h
> +++ b/tools/testing/selftests/bpf/bpf_experimental.h
> @@ -351,6 +351,13 @@ extern void bpf_iter_css_destroy(struct bpf_iter_css *it) __weak __ksym;
>  extern int bpf_wq_init(struct bpf_wq *wq, void *p__map, unsigned int flags) __weak __ksym;
>  extern int bpf_wq_start(struct bpf_wq *wq, unsigned int flags) __weak __ksym;
>  
> +struct bpf_thread_wq;
> +extern int bpf_thread_wq_init(struct bpf_thread_wq *twq, void *p__map,
> +			      __u64 cgroup_id,
> +			      unsigned int flags) __weak __ksym;
> +extern int bpf_thread_wq_start(struct bpf_thread_wq *twq,
> +			       unsigned int flags) __weak __ksym;
> +
>  struct bpf_iter_kmem_cache;
>  extern int bpf_iter_kmem_cache_new(struct bpf_iter_kmem_cache *it) __weak __ksym;
>  extern struct kmem_cache *bpf_iter_kmem_cache_next(struct bpf_iter_kmem_cache *it) __weak __ksym;

