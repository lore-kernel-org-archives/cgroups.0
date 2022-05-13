From: Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] kseltest/cgroup: Make test_stress.sh work if run
 interactively
Date: Fri, 13 May 2022 16:17:03 -0400
Message-ID: <Yn68vzyMIy4upGtq@lorien.usersys.redhat.com>
References: <20220513190928.676841-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652473027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1LW72Jjy9MKnDZ4qBo9AkKccKnp0hdNYiyWQhDRqlzQ=;
        b=B433sUzKUUBK9ITqlH/5/OxjEcvHiHHB4W6K73gni4Cmkpyr7JzUGwxewIBSb5TOMGTbCL
        PfEEVUBOf7KhIDxi6niePZF18cmYyC4rJQXGS+JtkA1ofCfHB2Pe1hSilTpgKnEl+NDjyl
        u4yI+x2kjZDnfWwJrydnvuX7Rdv0XbI=
Content-Disposition: inline
In-Reply-To: <20220513190928.676841-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Fri, May 13, 2022 at 03:09:28PM -0400 Waiman Long wrote:
> Commit 54de76c01239 ("kselftest/cgroup: fix test_stress.sh to use OUTPUT
> dir") changes the test_core command path from . to $OUTPUT. However,
> variable OUTPUT may not be defined if the command is run interactively.
> Fix that by using ${OUTPUT:-.} to cover both cases.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_stress.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_stress.sh b/tools/testing/selftests/cgroup/test_stress.sh
> index 109c044f715f..3c9c4554d5f6 100755
> --- a/tools/testing/selftests/cgroup/test_stress.sh
> +++ b/tools/testing/selftests/cgroup/test_stress.sh
> @@ -1,4 +1,4 @@
>  #!/bin/bash
>  # SPDX-License-Identifier: GPL-2.0
>  
> -./with_stress.sh -s subsys -s fork ${OUTPUT}/test_core
> +./with_stress.sh -s subsys -s fork ${OUTPUT:-.}/test_core
> -- 
> 2.27.0
> 


Thanks Waiman!  I did not think to try manually running it.


Cheers,
Phil

-- 

