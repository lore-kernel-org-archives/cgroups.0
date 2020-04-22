From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/18] mm: memcontrol: fix theoretical race in charge
 moving
Date: Wed, 22 Apr 2020 15:36:16 +0900
Message-ID: <20200422063615.GB6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CZSSzJnZ1MHzcmsWtWuWxkow51PnPw2IWZgspST+uVI=;
        b=ls5QfuFXXFiilf45USH7v+eQmuTJ3PHmJP7NplN6QLta76WP1KbKLw2xFzg1bKPU2w
         1uNvOi2bCmYUCIcqBXXs/uWK+5EQ5ffvG23l1PRQixBaa8YoNuph7ZYC0E2pKibWqQT+
         Kx1AJtKpffeBMLcBkSxf1Y5sqLCxT6289uSxh3vwNepMkHKeN/ufWMIOyFlm+fgvW/ue
         zuCTlvXNPDYcKZVY2CRsXxlhwYiCZyuPHEPGVdAlkToo0nRZpJcrUXWw/1SSm/oQLrWg
         OIQ61v4WXvivJqWuxywhk+BZasO3yh5ILcO+0jnXerym2Ch9CAjEZfsfE9PKDZSNOpNY
         2Qxw==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:10PM -0400, Johannes Weiner wrote:
> The move_lock is a per-memcg lock, but the VM accounting code that
> needs to acquire it comes from the page and follows page->mem_cgroup
> under RCU protection. That means that the page becomes unlocked not
> when we drop the move_lock, but when we update page->mem_cgroup. And
> that assignment doesn't imply any memory ordering. If that pointer
> write gets reordered against the reads of the page state -
> page_mapped, PageDirty etc. the state may change while we rely on it
> being stable and we can end up corrupting the counters.
> 
> Place an SMP memory barrier to make sure we're done with all page
> state by the time the new page->mem_cgroup becomes visible.
> 
> Also replace the open-coded move_lock with a lock_page_memcg() to make
> it more obvious what we're serializing against.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Thanks.
