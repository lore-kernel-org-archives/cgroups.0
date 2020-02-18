From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 5/9] hugetlb_cgroup: add accounting for shared
 mappings
Date: Tue, 18 Feb 2020 10:07:19 -0800
Message-ID: <40f86207-6f4d-1d00-b6ac-b837c20626ea@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-5-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=e3JY76Nw6Z8qX70Yw+VTwQiabRUZeD/vVIWatfgrW04=;
 b=IM0UnXqNMAWDp5h99bss7p2XZ7UfyP25Jwa03tDvRTM57+ywGz+cVbLLpCHfSFgJYP3L
 159R+3QwknVgwkxQ/q79T1rSf8YP/kABkV+A/zoGQeCdtwtHl+prT03PtTmG/QIk2MUB
 yIHNBHNa7FFPHxWL86DJUzFkdrnGapH0nBYRiMC6lhP1fRgjIDOh5qIEM/b5TErcsIbt
 W+UDZy2S3E1uJQJG9rffCMKlFMyEcNt0rze5VUSFJ0YB8XRsa0Cx6AxlfzerHgK00mAa
 1yEaTrlz+VcdDWP7Pk5ixR+9utbhuNOCpiv7Rt2qz4affGYre6vrpO7USqriFDtJ1LHE NQ== 
In-Reply-To: <20200211213128.73302-5-almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> For shared mappings, the pointer to the hugetlb_cgroup to uncharge lives
> in the resv_map entries, in file_region->reservation_counter.
> 
> After a call to region_chg, we charge the approprate hugetlb_cgroup, and if
> successful, we pass on the hugetlb_cgroup info to a follow up region_add call.
> When a file_region entry is added to the resv_map via region_add, we put the
> pointer to that cgroup in file_region->reservation_counter. If charging doesn't
> succeed, we report the error to the caller, so that the kernel fails the
> reservation.
> 
> On region_del, which is when the hugetlb memory is unreserved, we also uncharge
> the file_region->reservation_counter.
> 
> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

With addition of the build fix,
Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

-- 
Mike Kravetz
