From: Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 1/3] memcg, kmem: Use is_root_cache instead of hard code
Date: Thu, 24 Oct 2013 20:30:37 +0300
Message-ID: <5269593D.8000904@iki.fi>
References: <1382527875-10112-1-git-send-email-h.huangqiang@huawei.com> <1382527875-10112-2-git-send-email-h.huangqiang@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed/relaxed; d=
	messagingengine.com; h=message-id:date:from:mime-version:to:cc
	:subject:references:in-reply-to:content-type
	:content-transfer-encoding; s=smtpout; bh=3uCVm8+g9qjV8FILeJfneu
	Yqf78=; b=JT582tLwHQ744ZjUAP79SNjOMhrg8YNFVRcyMGAn7FH6AYeGHgkrAR
	18ZeqaEIR3fp+V5cXTuRolEx/SnVTwVKj1qh/34UPSjG7b8BFhYMUFAmlzHqWlUJ
	aDM5CQKGiDEjmsttjR2z3OVPN4fnV1wCIs2DWwQAQkWrgnHyFqn28=
In-Reply-To: <1382527875-10112-2-git-send-email-h.huangqiang@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qiang Huang <h.huangqiang@huawei.com>, akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@suse.cz, cl@linux-foundation.org, penberg@kernel.org, glommer@parallels.com, rientjes@google.com, cgroups@vger.kernel.org, linux-mm@kvack.org, lizefan@huawei.com

On 10/23/2013 02:31 PM, Qiang Huang wrote:
> Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
> ---
>   mm/memcontrol.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b73988a..15ad0e3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -57,6 +57,7 @@
>   #include <net/sock.h>
>   #include <net/ip.h>
>   #include <net/tcp_memcontrol.h>
> +#include "slab.h"
>   
>   #include <asm/uaccess.h>
>   
> @@ -3064,7 +3065,7 @@ int memcg_update_cache_size(struct kmem_cache *s, int num_groups)
>   {
>   	struct memcg_cache_params *cur_params = s->memcg_params;
>   
> -	VM_BUG_ON(s->memcg_params && !s->memcg_params->is_root_cache);
> +	VM_BUG_ON(!is_root_cache(s));
>   
>   	if (num_groups > memcg_limited_groups_array_size) {
>   		int i;

Reviewed-by: Pekka Enberg <penberg@kernel.org>

Andrew, I think your tree is the right place for these patches.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
