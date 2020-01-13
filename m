From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer list
Date: Mon, 13 Jan 2020 10:36:14 +0300
Message-ID: <20200113073614.jo2txcmazwlesl7b@box.shutemov.name>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
 <20200111000352.efy6krudecpshezh@box>
 <20200112022858.GA17733@richard>
 <20200112225718.5vqzezfclacujyx3@box>
 <20200113004457.GA27762@richard>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LuCWDSuVOHVDD0RBreB5I3crH+JdvuDeEnJ61QwIlv8=;
        b=lxxn4P4HGDQDftUPfcUemr7aW0pZLgel+N/hMr05xUbY+zyc2C1asmbnF6WPrEe2Cy
         u1IDuJpghF8gQzagcU0NMmHaVJC4muTGR1pTq+v9V9/kzo0AEL8uqQb9m4VJEi1ytNbR
         G2HU5EagSfAV5/K8u7iszKZ/zUWBPWWrMfDsfYJqp+POEF4FBiF6PsF2vJY/LdmBUb2j
         xeAI5U+PGhP0ScNDzJRKW7lGHn3YqkFDMBvv0mCjjIFr88NXimk4yZbuOwVeyrfXUHr/
         gFZvAgDZdLT4fuqPJ80e4hLpWqQmNcRTbeJPh3JigUeAuGHwaXOFEy3/INoEC0+kn/lD
         cHcg==
Content-Disposition: inline
In-Reply-To: <20200113004457.GA27762@richard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon, Jan 13, 2020 at 08:44:57AM +0800, Wei Yang wrote:
> >> It is possible two page in the same pgdate or memcg grab page lock
> >> respectively and then access the same defer queue concurrently.
> 
> If my understanding is correct, you agree with my statement?

Which one? If the one above then no. list_empty only accesses list_head
for the struct page, not the queue.

-- 
 Kirill A. Shutemov
