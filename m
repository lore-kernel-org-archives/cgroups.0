From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v10 2/8] hugetlb_cgroup: add interface for charge/uncharge
 hugetlb reservations
Date: Wed, 29 Jan 2020 13:21:52 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001291312490.175731@chino.kir.corp.google.com>
References: <20200115012651.228058-1-almasrymina@google.com> <20200115012651.228058-2-almasrymina@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=fSu1mCirRVJUEaT+xu3QH4J7cMfTuyOkl0e/HLlkDbU=;
        b=P/D+X34DyFIVyb02XfVKy0ez7sqi3JEfNxP0fAGOgGmxc1cVKQ9rGo+vjzEILUFZYY
         Th6TqFfL/TeL6mjRI1wEB1tf6SKODMXuKHiHGuUkNzirxDxr1isbiii+zASEv0IgrlMt
         XOk+l8dhoulN6hdPOkhiOypf3L8b2P+1jI+lfCTBd+RxcX5LtJoQGNa45TGmQl0gCAMy
         6+MTywXj7bOpvfE6pqDPCEil8nOdV7/3VBcmgVrxE4eNto2UBQkxzApfPQ97iURPOylx
         wJjgAC3U/gPQTvu2jiC/Q3wVMMMRHWtsnUvhcNxk9ON65oZcbx7eDZiCGIDSuRA7UJJt
         fx5w==
In-Reply-To: <20200115012651.228058-2-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org

On Tue, 14 Jan 2020, Mina Almasry wrote:

> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index 063962f6dfc6a..eab8a70d5bcb5 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -20,29 +20,37 @@
>  struct hugetlb_cgroup;
>  /*
>   * Minimum page order trackable by hugetlb cgroup.
> - * At least 3 pages are necessary for all the tracking information.
> + * At least 4 pages are necessary for all the tracking information.
>   */
>  #define HUGETLB_CGROUP_MIN_ORDER	2

I always struggle with a way to document and protect these types of 
usages.  In this case, we are using the private filed of tail pages; in 
thp code, we enumerate these usages separately in struct page: see "Tail 
pages of compound page" comment in the union.  Using the private field is 
fine to store a pointer to the hugetlb_cgroup, but I'm wondering if we can 
document or protect against future patches not understanding this usage.  
Otherwise it's implicit beyond this comment.

Maybe an expanded comment here is the only thing that is needed because 
it's unique to struct hugetlb_cgroup that describes what struct page 
represents for the second, third, and (now) fourth tail page.

Or, we could go even more explicit and define an enum that defines the 
third tail page is for hugetlb_cgroup limits and fourth is for 
hugetlb_cgroup reservation limits.

enum {
...
	H_CG_LIMIT,
	H_CG_RESV,
	MAX_H_CG_PRIVATE,
};

and then do a

BUILD_BUG_ON(MAX_H_CG_PRIVATE > (1 << HUGETLB_CGROUP_MIN_ORDER));

somewhere?  And then use H_CG_RESV (or a better name) as the offset from 
the head page in the code?

> 
>  #ifdef CONFIG_CGROUP_HUGETLB
> 
> -static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page,
> +							      bool reserved)

When implementing specs, I immediately see "bool reserved" or 
"int reserved:1" as reserved for future use :)  Maybe simple enough to 
just name these formals as resv?

Otherwise looks like a simple conversion of existing functionality and 
extension to the new limits.

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
