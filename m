From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Patch v2 2/3] mm/memcg: __mem_cgroup_remove_exceeded could
 handle a !on-tree mz properly
Date: Mon, 14 Mar 2022 22:51:50 +0000
Message-ID: <20220314225150.fhwny4yhxgjevwxx@master>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-2-richard.weiyang@gmail.com>
 <Yi8Qu/1V4H1M9qZV@dhcp22.suse.cz>
Reply-To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wCeR5z7Z9I0OZ5CW9/ENgLziIVfJwONuLcSxsmCrGvQ=;
        b=C0C8NN3xNrpb0KoqYriDF0/coODFEYWWLzYOmoHnZsjra3mm06pm8YS0CMGKFLt21h
         d4xtohTHd3MOFp9xPgAKmy0nXJ9B7PV7He5Eh6K+4Cb4BXdxHUMBQ8gR0gTnvwhdqfqQ
         d8QZA0r26ZW7orl+WkOUjr1mqXxWk1UeBzJRuoMT0TRM6Vm3xzLfA8OYL8OE+Qa+Wc2s
         oo72lh8kFvnijMO8WnuQDRAvIQDQuQEVGDu4/LdvDKzpjyVDEi6SZk2+0ouqqAIiwoAc
         qMCkkLK+Vy/bRn4QOskN46wbNMNVONWyeZtF/FI9lTRWxBh0RChuviSAXIRryv8SvqoX
         +n3w==
Content-Disposition: inline
In-Reply-To: <Yi8Qu/1V4H1M9qZV-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, Mar 14, 2022 at 10:54:03AM +0100, Michal Hocko wrote:
>On Sat 12-03-22 07:16:22, Wei Yang wrote:
>> There is no tree operation if mz is not on-tree.
>
>This doesn't explain problem you are trying to solve nor does it make
>much sense to me TBH.
>

This just tries to make the code looks consistent.

>> Let's remove the extra check.
>
>What would happen if the mz was already in the excess tree and the
>excess has grown?

The purpose mem_cgroup_update_tree() is to update the soft limit tree. And the
approach is to remove and add it back to the tree with new excess.

I don't get your point for this question.


-- 
Wei Yang
Help you, Help me
