From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/18] mm: fix NUMA node file count error in
 replace_page_cache()
Date: Wed, 22 Apr 2020 15:34:11 +0900
Message-ID: <20200422063357.GA6780@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cNPk7dyrNsunZ6orqrkHd3dWM4T8VDBKi6CmTIj2FrI=;
        b=M2VzN4hLhiH0xZ3XfNmNlGsb5z71UEM7bOyLibiJrUfqzWnsr7Mnho6vtHE/m4Si0v
         lnCn+vZHkutsNSoFUaoObLyQiQSLmg2E532x3z54L9M827P0YXucnSwhA9qoFbPgLZYo
         6Pnn7OD2T+2mft6/ZrVBqjr0Z8Ia+jWOrzp/UEJQUDs5z096V3X2fOD5cVO1szM/Osar
         MC4rKQaH88JrQvya16KDxQlKEJnatD7NZPCiq5AMNNXi5TrKQHsT+Y2049Noj50KK5GE
         xNN6BnnrnU38ST/mJuA5+lzdnq8CaNQK5ozCSe1BGa4cBaHzURGRTJKAOhW/d2ZL/Ba4
         lD2g==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:09PM -0400, Johannes Weiner wrote:
> When replacing one page with another one in the cache, we have to
> decrease the file count of the old page's NUMA node and increase the
> one of the new NUMA node, otherwise the old node leaks the count and
> the new node eventually underflows its counter.
> 
> Fixes: 74d609585d8b ("page cache: Add and replace pages using the XArray")
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Thanks.
