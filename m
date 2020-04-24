From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 12/18] mm: memcontrol: convert anon and file-thp to new
 mem_cgroup_charge() API
Date: Fri, 24 Apr 2020 09:29:54 +0900
Message-ID: <20200424002953.GB13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-13-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VKBqm9dD1eT/9SukXzSTV56tiVVlcyEzdR7J/pmXPKk=;
        b=m89Egqb1/fpd9kMAnDYFVXpT/PykNFJynjooI9IkfNzptBO0nn6hRNuNFqW+S9/cQs
         I2G7BCUXvItMqimgVATxYqv+RILMmTTE4djYombXNLu7Z7n0bl+CqXPnvz16U6EO34Wm
         Cl2DFf5an4Lcfssj4J58eZqy/CAEkTbf154kGv5vfvMg/Ja8TA+7tat/vCLcw43k8XfA
         DepdD4VhfU78IPl278F8nFbHfOZ1CVrF/InsmkhRejTmrYOorm+sADgK48QqPxeygD27
         7nQGN83N0yfvNd32LTvpnEtyHVNpEDdIg/dI0uCv/eAo+I6Q5DjtOMEeNrU755zx2Olf
         j1bw==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-13-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:20PM -0400, Johannes Weiner wrote:
> With the page->mapping requirement gone from memcg, we can charge anon
> and file-thp pages in one single step, right after they're allocated.
> 
> This removes two out of three API calls - especially the tricky commit
> step that needed to happen at just the right time between when the
> page is "set up" and when it's "published" - somewhat vague and fluid
> concepts that varied by page type. All we need is a freshly allocated
> page and a memcg context to charge.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
