From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Add memory.transparent_hugepage_disabled
Date: Tue, 24 Mar 2020 12:17:11 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.2003241215580.34058@chino.kir.corp.google.com>
References: <1585045916-27339-1-git-send-email-teawater@gmail.com> <20200324121758.paxxthsi2f4hngfa@box>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Rh4HBg/agEMeOOZna2pzZhd8r6lKpuw8m53EKKUPZHc=;
        b=tIMOfdTlHbbOdLWgQGt6oJeQvoMFtQVTFpy2pLi7nTYBlhcgtjoQBFLNrAmUCFix+T
         Wp/wocBxPQTXgY7/RgRBxViOlX3qvt4qAYEk/YW1KHupUy3P9tp2KaMOzrX0R6sTFgf6
         PliVP2qUb/uLXnzP8BjH8l1c4dAaUAh3rFpjd7ig+b66BRc+pgAFmsMRdIB6fEqjczvQ
         yQTmo6/rDRuUJ5/DZl7UmqTf1BXpa/ALNbK4+wuduHiTGxYnqbqiVNJ6K3EZFv9wHg8E
         xLxeTBC5Y9IaRg2G++TFA5LGhvZDI2ZYBb4si3IViJ1w3uXfMxd2yLIR9+XuIcNGFgWl
         9f3w==
In-Reply-To: <20200324121758.paxxthsi2f4hngfa@box>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: Hui Zhu <teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, thellstrom-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hui Zhu <teawaterz-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

On Tue, 24 Mar 2020, Kirill A. Shutemov wrote:

> On Tue, Mar 24, 2020 at 06:31:56PM +0800, Hui Zhu wrote:
> > /sys/kernel/mm/transparent_hugepage/enabled is the only interface to
> > control if the application can use THP in system level.
> 
> No. We have prctl(PR_SET_THP_DISABLE) too.
> 

Yeah, I think this is the key point since this can be inherited across 
fork and thus you already have the ability to disable thp for a process 
where you cannot even modify the binary to do MADV_NOHUGEPAGE.
