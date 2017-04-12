From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 2/6] mm, mempolicy: stop adjusting current->il_next in
 mpol_rebind_nodemask()
Date: Wed, 12 Apr 2017 16:16:26 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1704121607520.28335@east.gentwo.org>
References: <20170411140609.3787-1-vbabka@suse.cz> <20170411140609.3787-3-vbabka@suse.cz> <alpine.DEB.2.20.1704111227080.25069@east.gentwo.org> <9665a022-197a-4b02-8813-66aca252f0f9@suse.cz> <97045760-77eb-c892-9bcb-daad10a1d91d@suse.cz>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <97045760-77eb-c892-9bcb-daad10a1d91d-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

On Wed, 12 Apr 2017, Vlastimil Babka wrote:

> >> Well, interleave_nodes() will then potentially return a node outside of
> >> the allowed memory policy when its called for the first time after
> >> mpol_rebind_.. . But thenn it will find the next node within the
> >> nodemask and work correctly for the next invocations.
> >
> > Hmm, you're right. But that could be easily fixed if il_next became il_prev, so
> > we would return the result of next_node_in(il_prev) and also store it as the new
> > il_prev, right? I somehow assumed it already worked that way.

Yup that makes sense and I thought about that when I saw the problem too.

> @@ -863,6 +856,18 @@ static int lookup_node(unsigned long addr)
>  	return err;
>  }
>
> +/* Do dynamic interleaving for a process */
> +static unsigned interleave_nodes(struct mempolicy *policy, bool update_prev)

Why do you need an additional flag? Would it not be better to always
update and switch the update_prev=false case to simply use
next_node_in()?

> +{
> +	unsigned next;
> +	struct task_struct *me = current;
> +
> +	next = next_node_in(me->il_prev, policy->v.nodes);
> +	if (next < MAX_NUMNODES && update_prev)
> +		me->il_prev = next;
> +	return next;
> +}
> +
>  /* Retrieve NUMA policy */
>  static long do_get_mempolicy(int *policy, nodemask_t *nmask,
>  			     unsigned long addr, unsigned long flags)
> @@ -916,7 +921,7 @@ static long do_get_mempolicy(int *policy, nodemask_t *nmask,
>  			*policy = err;
>  		} else if (pol == current->mempolicy &&
>  				pol->mode == MPOL_INTERLEAVE) {
> -			*policy = current->il_next;
> +			*policy = interleave_nodes(current->mempolicy, false);

Here
