From: Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH 10/10] blkcg: implement BPF_PROG_TYPE_IO_COST
Date: Fri, 14 Jun 2019 12:32:09 +0100
Message-ID: <e4d1df7b-66bb-061a-8ecb-ff1e5be3ab1d@netronome.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614015620.1587672-11-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8nVWJoeY39suIIZgzswj4aacVGQOKuAApyinJQUDhzc=;
        b=wISeSxpdrtKy6YhXKfQtLkE0GD4kqa0Oy/ToMDpugnOr/zje0ASKBMqfYVlwFAJ7g9
         qXKsNUHtAnPBZUlTbwYFb8A5Qo5d+LAh2OFvLBIJSpsDjbeow7PfCwXVKA9lHIH5pTOl
         ytn8W8OncmzZ4Z/wB28QLVHWqJmr0J74T6Z4BUSEI6y+qhdIoIpAU2TLCtOlufQIPRgd
         pJKe0B4Ub69eLYUbHVNtoo3gERByIWNNtz3dyGwTnmCCRNZjpxm+Rzdhp8ilmSVzo55a
         9FDw6931BM5c3Sb4T7JFrD7hdknJooQM1Ph79P9CZiOO/2NLv+03hFFoAHE266bJexg0
         gU+A==
In-Reply-To: <20190614015620.1587672-11-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

2019-06-13 18:56 UTC-0700 ~ Tejun Heo <tj@kernel.org>
> Currently, blkcg implements one builtin IO cost model - lienar.  To
> allow customization and experimentation, allow a bpf program to
> override IO cost model.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---

[...]

> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index d672d9086fff..beeac8ac48f3 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -383,6 +383,9 @@ static void probe_kernel_image_config(void)
>  		/* bpftilter module with "user mode helper" */
>  		"CONFIG_BPFILTER_UMH",
>  
> +		/* Block */
> +		"CONFIG_BLK_IO_COST",
> +
>  		/* test_bpf module for BPF tests */
>  		"CONFIG_TEST_BPF",
>  	};
> diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
> index 3d63feb7f852..298e53f35573 100644
> --- a/tools/bpf/bpftool/main.h
> +++ b/tools/bpf/bpftool/main.h
> @@ -74,6 +74,7 @@ static const char * const prog_type_name[] = {
>  	[BPF_PROG_TYPE_SK_REUSEPORT]		= "sk_reuseport",
>  	[BPF_PROG_TYPE_FLOW_DISSECTOR]		= "flow_dissector",
>  	[BPF_PROG_TYPE_CGROUP_SYSCTL]		= "cgroup_sysctl",
> +	[BPF_PROG_TYPE_IO_COST]			= "io_cost",
>  };
>  
>  extern const char * const map_type_name[];

Hi Tejun,

Please make sure to update the documentation and bash
completion when adding the new type to bpftool. You
probably want something like the diff below.

Thanks,
Quentin


diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 228a5c863cc7..0ceae71c07a8 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -40,7 +40,7 @@ PROG COMMANDS
 |              **lwt_seg6local** | **sockops** | **sk_skb** | **sk_msg** | **lirc_mode2** |
 |              **cgroup/bind4** | **cgroup/bind6** | **cgroup/post_bind4** | **cgroup/post_bind6** |
 |              **cgroup/connect4** | **cgroup/connect6** | **cgroup/sendmsg4** | **cgroup/sendmsg6** |
-|              **cgroup/sysctl**
+|              **cgroup/sysctl** | **io_cost**
 |      }
 |       *ATTACH_TYPE* := {
 |              **msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 2725e27dfa42..057590611e63 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -378,7 +378,7 @@ _bpftool()
                                 cgroup/connect4 cgroup/connect6 \
                                 cgroup/sendmsg4 cgroup/sendmsg6 \
                                 cgroup/post_bind4 cgroup/post_bind6 \
-                                cgroup/sysctl" -- \
+                                cgroup/sysctl io_cost" -- \
                                                    "$cur" ) )
                             return 0
                             ;;
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 1f209c80d906..6ba1d567bf17 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1070,7 +1070,7 @@ static int do_help(int argc, char **argv)
                "                 sk_reuseport | flow_dissector | cgroup/sysctl |\n"
                "                 cgroup/bind4 | cgroup/bind6 | cgroup/post_bind4 |\n"
                "                 cgroup/post_bind6 | cgroup/connect4 | cgroup/connect6 |\n"
-               "                 cgroup/sendmsg4 | cgroup/sendmsg6 }\n"
+               "                 cgroup/sendmsg4 | cgroup/sendmsg6 | io_cost }\n"
                "       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
                "                        flow_dissector }\n"
                "       " HELP_SPEC_OPTIONS "\n"
