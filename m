From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer
 list
Date: Tue, 14 Jan 2020 19:26:53 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001141924330.114086@chino.kir.corp.google.com>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com> <20200111000352.efy6krudecpshezh@box> <20200114093122.GH19428@dhcp22.suse.cz> <20200114103112.o6ozdbkfnzdsc2ke@box> <20200114105921.eo2vdwikrvtt3gkb@box> <20200115010722.GA4916@richard>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=Iae/mJgVCLpfLGSuYynupuWE+Z4MahohKNOA3VuWzvQ=;
        b=bpGcNk0KuEcv+Ht10XLkBn/HP68yrADkbQzthX19bcUJf/xKxwL4QilvYOrq63iLtP
         QXHGouASBxogJp3LM3yUP91HjYlur9dWJbk1ZdvMkGziZgmXfsEb4avARPSYrYz4rAi2
         OvLl6gWqyFfYMDOctvwF2bIE93PVsy8D7diUVOYObx1xhI1j8NNS0J3jP1ta1FEOYUhN
         fJkqV4C0RQGqlxMN8DMVvJKf7dAkzkAKKtQ1NBTJvxMf445Hmw2mTio4MwQ4BCYmKke0
         akfN3Qikj18K8eS4W8yDU5sAvOYFxPTnfoLGu4VRBE1cm/xaJ5NtSGJk5PobXwkuqimc
         oTRw==
In-Reply-To: <20200115010722.GA4916@richard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, 15 Jan 2020, Wei Yang wrote:

> >split_huge_page_to_list() has page lock taken.
> >
> >free_transhuge_page() is in the free path and doesn't susceptible to the
> >race.
> >
> >deferred_split_scan() is trickier. list_move() should be safe against
> >list_empty() as it will not produce false-positive list_empty().
> >list_del_init() *should* (correct me if I'm wrong) be safe because the page
> >is freeing and memcg will not touch the page anymore.
> >
> >deferred_split_huge_page() is a problematic one. It called from
> >page_remove_rmap() path witch does require page lock. I don't see any
> >obvious way to exclude race with mem_cgroup_move_account() here.
> >Anybody else?
> 
> If my understanding is correct, the reason is deferred_split_huge_page()
> doesn't has page lock taken, right?
> 

I think the fix that you have proposed has inspired some deeper looks at 
the locking around the deferred split queue and the hope was that perhaps 
this could be protected by the page lock but it was found that at least in 
one path that isn't taken.  So I believe your fix is still needed and any 
possible optimizations in this area can be proposed on top.
