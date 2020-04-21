From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 01/18] mm: fix NUMA node file count error in replace_page_cache()
Date: Tue, 21 Apr 2020 12:13:34 -0700
Message-ID: <CALvZod4Rc0a1LBE7DCa0U8xA3a3N1u7g=mDjRw0cJEzvK62vmA@mail.gmail.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org> <20200420221126.341272-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a/+YOMpTdK2B7DWfew1yvduwiCraaW2/kuntapldYZ0=;
        b=bUWoO33YlTxWoYWiORjP3cfd0fXYcJlwyVFVKaoJXnsvHiP4GSzVRDCjxFF08py8lN
         5ZUrKIqEk822Szjrlp1a4M6EooH0kyC/WpUqGiVwtSTYmjBfkxKXaIUk0OCxAPeXkyQt
         /6fuXhRJIF6ZD/CXoAAPg2r9Quv9ZDfp9xAv0Cx9MdvuVu74+9KjyhWDEj5qnLon4d8u
         nXYnLbO9ypaVJ5RXViyX+EC3kVxDVZ/QAZZ0OD1acVRZBUPXSJSR2gBVHUcVu1xrfS9Y
         rXdzeb62flwCVklON1DT44s3z++HTQophQ/mY77/dUZF7wNPPJZa/MEoe1DHqIarJdWt
         LZ4w==
In-Reply-To: <20200420221126.341272-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Mon, Apr 20, 2020 at 3:11 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> When replacing one page with another one in the cache, we have to
> decrease the file count of the old page's NUMA node and increase the
> one of the new NUMA node, otherwise the old node leaks the count and
> the new node eventually underflows its counter.
>
> Fixes: 74d609585d8b ("page cache: Add and replace pages using the XArray")
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
