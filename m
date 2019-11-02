From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm/memcontrol: update documentation about invoking oom
 killer
Date: Sat, 2 Nov 2019 16:55:37 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1911021654020.34229@chino.kir.corp.google.com>
References: <157270779336.1961.6528158720593572480.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=z0bgko71g/IEmBKD3Kro6mR4U+O8GKl/Z/Ms7dBzsH4=;
        b=Y0grKuDcaYtkpumf209OEt0taRJ7Y6eOtn7rvFJPq1VMFZ+BoXqfMZNRq9rLCrW12u
         D8VNlbfWEqIKt3A1Wl+k1SxaU9X2kXhZXXesNApA/aYan2qyIkNS8pgyMMfIvkD0w4VS
         U6msNXpe1KK9KZZGIiGmJNMpwNFaKC+VtlKzW5GbBSjRIjnen7Tk66LtCmd6uh5QJN6G
         8oIubEqXAwVIFxaXfQiQrJEYD0VQHXDkafpol8yjZhyMnR0FWJGrB2uvS0BHdLFhgof7
         K7QbS5Styk3SYEeVaUYq45g2bzeTAhcNl2Lg/i35OjWCROKCu7YX5GPeBPv+2Rq222E3
         dl9g==
In-Reply-To: <157270779336.1961.6528158720593572480.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@suse.com>

On Sat, 2 Nov 2019, Konstantin Khlebnikov wrote:

> Since commit 29ef680ae7c2 ("memcg, oom: move out_of_memory back to the
> charge path") memcg invokes oom killer not only for user page-faults.
> This means 0-order allocation will either succeed or task get killed.
> 
> Fixes: 8e675f7af507 ("mm/oom_kill: count global and memory cgroup oom kills")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 5361ebec3361..eb47815e137b 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1219,8 +1219,13 @@ PAGE_SIZE multiple when read back.
>  
>  		Failed allocation in its turn could be returned into
>  		userspace as -ENOMEM or silently ignored in cases like
> -		disk readahead.  For now OOM in memory cgroup kills
> -		tasks iff shortage has happened inside page fault.
> +		disk readahead.
> +
> +		Before 4.19 OOM in memory cgroup killed tasks iff
> +		shortage has happened inside page fault, random
> +		syscall may fail with ENOMEM or EFAULT. Since 4.19
> +		failed memory cgroup allocation invokes oom killer and
> +		keeps retrying until it succeeds.
>  
>  		This event is not raised if the OOM killer is not
>  		considered as an option, e.g. for failed high-order

The previous text is obviously incorrect for today's kernels, but I'm 
curious if we should be conflating the documentation here by describing 
the pre-4.19 behavior.  OOM killing no longer happens only on page fault 
so maybe better to document the exact behavior today and not attempt to 
describe differences with previous versions?
