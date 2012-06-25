From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 10/11] memcg: allow a memcg with kmem charges to be
 destructed.
Date: Mon, 25 Jun 2012 11:34:42 -0700
Message-ID: <20120625183442.GG3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-11-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=U6YEUUKf0tMAcNVWWSQGjd8gPtV1FTmMLT3kuN7SSF4=;
        b=eozXgkoyL6iA/Jl8jpYTMyWsnb4pufDVnsn8D0lzXrG6otWuJGWlXtgyvq1hFEovFn
         3Vxbx+2/w+Si2QoQ1NLQRW+QDTDbM3PXzzbNh4aITlqzJtzB4QQ9VNFW+SyBhOe1DJQz
         ScaYaAQOZb02A1waS67oLC8GP3LkdaLR4lfy0Ii7HEzUDn0PIYycvfiBEIBmcm8ykBb9
         LKIm1tfp8Ncq6P15NcfHCMNPP4pXp5Jtjokss2eQoPNOJrwccwn0VURDzANLFSjIeZm6
         CxOCNxNV2CUYPpucSvxZKTHuuxtmwtcli8roX1bAmzRpb0PfAgNGFGQPe4r++jQZwxQV
         Jiag==
Content-Disposition: inline
In-Reply-To: <1340633728-12785-11-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On Mon, Jun 25, 2012 at 06:15:27PM +0400, Glauber Costa wrote:
> Because the ultimate goal of the kmem tracking in memcg is to
> track slab pages as well, we can't guarantee that we'll always
> be able to point a page to a particular process, and migrate
> the charges along with it - since in the common case, a page
> will contain data belonging to multiple processes.
> 
> Because of that, when we destroy a memcg, we only make sure
> the destruction will succeed by discounting the kmem charges
> from the user charges when we try to empty the cgroup.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Christoph Lameter <cl@linux.com>
> CC: Pekka Enberg <penberg@cs.helsinki.fi>
> CC: Michal Hocko <mhocko@suse.cz>
> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> CC: Suleiman Souhlal <suleiman@google.com>
> ---
>  mm/memcontrol.c |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a6a440b..bb9b6fe 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -598,6 +598,11 @@ static void disarm_kmem_keys(struct mem_cgroup *memcg)
>  {
>  	if (test_bit(KMEM_ACCOUNTED_THIS, &memcg->kmem_accounted))
>  		static_key_slow_dec(&mem_cgroup_kmem_enabled_key);
> +	/*
> +	 * This check can't live in kmem destruction function,
> +	 * since the charges will outlive the cgroup
> +	 */
> +	BUG_ON(res_counter_read_u64(&memcg->kmem, RES_USAGE) != 0);

WARN_ON() please.  Misaccounted kernel usually is better than dead
kernel.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
