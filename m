From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/18] mm: memcontrol: prepare move_account for removal
 of private page type counters
Date: Wed, 22 Apr 2020 15:41:38 +0900
Message-ID: <20200422064138.GG6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-8-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iHdvDOllQWAa51R+Fb+AFKea2IfMdQevdkCOltYp2Bg=;
        b=ZVWkRcS052Kc6o3h3NDPurylsN58IsNi3UfUKY6ZB4/enpkd4UC5OC/GNbgrjlmXR4
         0bbbIzvjh8nJRwQ9mYUK5cCuAyJkY7OnwHGemniWr9zZLfI+przXMtp69I8t/vKr+Ycz
         yxQXvekQMg/bEE+Yjjry3/vVWH2Y/ILe3QmE90cQTlmL1p4WHPcOQ9mXOcu/dcypSOJI
         9dor/2cX33nDx9lDz5rhEmADMhqv2x2kkmX8mbEN2RjP/RMDPPWzqzZu12ylEX5sczz5
         TR/5X09hqnJfmKZLW4i8Bw9xYsorD21TGEZUAjAWRUY7WbuvQ5sTw3FNEyL4kEqnm5QC
         iQCg==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-8-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:15PM -0400, Johannes Weiner wrote:
> When memcg uses the generic vmstat counters, it doesn't need to do
> anything at charging and uncharging time. It does, however, need to
> migrate counts when pages move to a different cgroup in move_account.
> 
> Prepare the move_account function for the arrival of NR_FILE_PAGES,
> NR_ANON_MAPPED, NR_ANON_THPS etc. by having a branch for files and a
> branch for anon, which can then divided into sub-branches.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

