From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] percpu: improve percpu_alloc_percpu event trace
Date: Sat, 7 May 2022 17:51:16 +0300
Message-ID: <e1c09bbb-2c58-a986-c704-1db538da905a@openvz.org>
References: <8d627f02-183f-c4e7-7c15-77b2b438536b@openvz.org>
 <202205070420.aAhuqpYk-lkp@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=02wpqp8xpRGu2+8JalnAVxZsm7qbiJHHSn2LDlYoYaQ=;
        b=OJC5lF5CMuih3uExbYLbioQn6rym2GPOBEXvkYU/5XM2Xds9sd42UAsNzTdWJ0dEbM
         7jB167FTrjKapqwm/vlr6k/W0zw44A/X5T18h8CuTrAr4PC/X6lPc4ZrCf0LRp8HWZjV
         DFV6Hg/9O+BtJihAYPXPZQN2raIzhxptV2Bbuzw3NB8UDjxLbgfSLbKUEV5KXWu06DF4
         gdJaBpXmFSv1cKfJ8omRIXStgJ9Xdjb9ULECamCee3FzEWRngtE28OGnPXw7YGIaq9nC
         MU5KaQTZ/wwe+UIXkxW+ov0ge0mBz9P94PT0LSouQQJN4IsWWZPJUHv0x6+Tp6RvTPSH
         q8cQ==
Content-Language: en-US
In-Reply-To: <202205070420.aAhuqpYk-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 5/6/22 23:38, kernel test robot wrote:
>>> include/trace/events/percpu.h:11:1: sparse: sparse: cast from restricted gfp_t
>>> include/trace/events/percpu.h:11:1: sparse: sparse: incorrect type in argument 3 (different base types) @@     expected unsigned long flags @@     got restricted gfp_t [usertype] gfp_flags @@
>    include/trace/events/percpu.h:11:1: sparse:     expected unsigned long flags
>    include/trace/events/percpu.h:11:1: sparse:     got restricted gfp_t [usertype] gfp_flags
>    mm/percpu.c: note: in included file (through include/trace/trace_events.h, include/trace/define_trace.h, include/trace/events/percpu.h):
>>> include/trace/events/percpu.h:11:1: sparse: sparse: cast to restricted gfp_t
>>> include/trace/events/percpu.h:11:1: sparse: sparse: cast to restricted gfp_t
>>> include/trace/events/percpu.h:11:1: sparse: sparse: restricted gfp_t degrades to integer
>>> include/trace/events/percpu.h:11:1: sparse: sparse: restricted gfp_t degrades to integer
>    mm/percpu.c:2012:24: sparse: sparse: context imbalance in 'pcpu_balance_free' - unexpected unlock

The same messages are generated for any other gfp_t argument in trace events.
As far as I understand it is not a bug per se,
but trace macros lacks __force attribute in 'gfp_t'-> 'unsigned long' casts.
The same thing happens with mode_t and with some other places using __print_flags()
for __bitwise marked types.

I can make sparse happy, here and elsewhere but it requires a lot of __force attributes.
Is anyone interested in such patches, or can we silently ignore these messages?

Need to add __force attribute to all entries in __def_gfpflag_names array
and add few changes into trace description, below is an example.

> vim +11 include/trace/events/percpu.h
> 
> df95e795a72289 Dennis Zhou   2017-06-19  10  
> df95e795a72289 Dennis Zhou   2017-06-19 @11  TRACE_EVENT(percpu_alloc_percpu,
> df95e795a72289 Dennis Zhou   2017-06-19  12  
> df95e795a72289 Dennis Zhou   2017-06-19  13  	TP_PROTO(bool reserved, bool is_atomic, size_t size,
> dee6876db0a7a4 Vasily Averin 2022-05-06  14  		 size_t align, void *base_addr, int off,
> dee6876db0a7a4 Vasily Averin 2022-05-06  15  		 void __percpu *ptr, size_t bytes_alloc, gfp_t gfp_flags),
> df95e795a72289 Dennis Zhou   2017-06-19  16  
> dee6876db0a7a4 Vasily Averin 2022-05-06  17  	TP_ARGS(reserved, is_atomic, size, align, base_addr, off, ptr,
> dee6876db0a7a4 Vasily Averin 2022-05-06  18  		bytes_alloc, gfp_flags),
> df95e795a72289 Dennis Zhou   2017-06-19  19  
> df95e795a72289 Dennis Zhou   2017-06-19  20  	TP_STRUCT__entry(
> df95e795a72289 Dennis Zhou   2017-06-19  21  		__field(	bool,			reserved	)
> df95e795a72289 Dennis Zhou   2017-06-19  22  		__field(	bool,			is_atomic	)
> df95e795a72289 Dennis Zhou   2017-06-19  23  		__field(	size_t,			size		)
> df95e795a72289 Dennis Zhou   2017-06-19  24  		__field(	size_t,			align		)
> df95e795a72289 Dennis Zhou   2017-06-19  25  		__field(	void *,			base_addr	)
> df95e795a72289 Dennis Zhou   2017-06-19  26  		__field(	int,			off		)
> df95e795a72289 Dennis Zhou   2017-06-19  27  		__field(	void __percpu *,	ptr		)
> dee6876db0a7a4 Vasily Averin 2022-05-06  28  		__field(	size_t,			bytes_alloc	)
> dee6876db0a7a4 Vasily Averin 2022-05-06  29  		__field(	gfp_t,			gfp_flags	)
VvS: need to replace gfp_t to unsigned long ...

> df95e795a72289 Dennis Zhou   2017-06-19  30  	),
> df95e795a72289 Dennis Zhou   2017-06-19  31  	TP_fast_assign(
> df95e795a72289 Dennis Zhou   2017-06-19  32  		__entry->reserved	= reserved;
> df95e795a72289 Dennis Zhou   2017-06-19  33  		__entry->is_atomic	= is_atomic;
> df95e795a72289 Dennis Zhou   2017-06-19  34  		__entry->size		= size;
> df95e795a72289 Dennis Zhou   2017-06-19  35  		__entry->align		= align;
> df95e795a72289 Dennis Zhou   2017-06-19  36  		__entry->base_addr	= base_addr;
> df95e795a72289 Dennis Zhou   2017-06-19  37  		__entry->off		= off;
> df95e795a72289 Dennis Zhou   2017-06-19  38  		__entry->ptr		= ptr;
> dee6876db0a7a4 Vasily Averin 2022-05-06  39  		__entry->bytes_alloc	= bytes_alloc;
> dee6876db0a7a4 Vasily Averin 2022-05-06  40  		__entry->gfp_flags	= gfp_flags;
VvS: ... and use here (__force unsigned long)

> df95e795a72289 Dennis Zhou   2017-06-19  41  	),
> df95e795a72289 Dennis Zhou   2017-06-19  42  
> dee6876db0a7a4 Vasily Averin 2022-05-06  43  	TP_printk("reserved=%d is_atomic=%d size=%zu align=%zu base_addr=%p off=%d ptr=%p bytes_alloc=%zu gfp_flags=%s",
> df95e795a72289 Dennis Zhou   2017-06-19  44  		  __entry->reserved, __entry->is_atomic,
> df95e795a72289 Dennis Zhou   2017-06-19  45  		  __entry->size, __entry->align,
> dee6876db0a7a4 Vasily Averin 2022-05-06  46  		  __entry->base_addr, __entry->off, __entry->ptr,
> dee6876db0a7a4 Vasily Averin 2022-05-06  47  		  __entry->bytes_alloc, show_gfp_flags(__entry->gfp_flags))
> df95e795a72289 Dennis Zhou   2017-06-19  48  );
> df95e795a72289 Dennis Zhou   2017-06-19  49  
 Thank you,
	Vasily Averin
