From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v11 4/9] hugetlb: disable region_add file_region
 coalescing
Date: Wed, 5 Feb 2020 15:57:17 -0800
Message-ID: <cd457f80-2624-f524-36ce-f11b56b30f8a@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-4-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=20EhFCbhIcHFyvZXL9v1kH+4dXx2cB7lh5BIdcgVgYg=;
 b=tV5i05UsAm74oB5wBtMplQ9bRCxAZGrWG9RDTuDn/v7ZDA56FfuTZPt1nzVC+W18NAoD
 d8QGNv+GAwz7HdMQS2puNqa2vkiC00xCoJuYDtwBCaGuDqAlIwDPsxxPr00vI/Ymai1G
 XWH74yaId+jPw7TBCdy9bzGFG5ybNne8mDO5jD6stEmmG9QaSXXfxvmQm0/VqXU9Epc6
 GJMJN4jcnCEgaHUsT6cFyOdEc7n4iiL5wvr9HVEu6td4GSZJeCuuLYpYeIuWkK1mcAL+
 C0tNdnEaLahhU1I0zldtydPf6O9gY/xpkVHCNCxjdy1ZIPMf0DIbDHtuwxrQ1J+wyq56 5Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=20EhFCbhIcHFyvZXL9v1kH+4dXx2cB7lh5BIdcgVgYg=;
 b=IXYlQMtjrp26qQLcJhlH1+yPliIpbXYSmzlrQLyf+Y4E+Y2a32Lg/DuXn94gYJzSqx6K
 7duY2xsG5wBA8nbBVvOmMx3jrTMsMZDhz8gGWm3CaVJ3x6pKlqiwu68dK+f9f4k7HliW
 Mk0+FsiTFqEw9plVng2ySqPMtim53P+4k6sN3AkQZHV70TFOTfcIDPJe+oZxzKQebUL1
 UoaEIbHXFBCAjV4o+alZvyRLVB/MLFN6RLZeqd/4Sc0otpeTkDFe5GeO8B0KI+HbIF7h
 yBt4wyijrfeg7y+i3ypR8qwpLkfqPSgy8wT68LEIPLb9XI6OK5/B8c+Lsbtl5k5WAhdC YA== 
In-Reply-To: <20200203232248.104733-4-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On 2/3/20 3:22 PM, Mina Almasry wrote:
> A follow up patch in this series adds hugetlb cgroup uncharge info the
> file_region entries in resv->regions. The cgroup uncharge info may
> differ for different regions, so they can no longer be coalesced at
> region_add time. So, disable region coalescing in region_add in this
> patch.
> 
> Behavior change:
> 
> Say a resv_map exists like this [0->1], [2->3], and [5->6].
> 
> Then a region_chg/add call comes in region_chg/add(f=0, t=5).
> 
> Old code would generate resv->regions: [0->5], [5->6].
> New code would generate resv->regions: [0->1], [1->2], [2->3], [3->5],
> [5->6].
> 
> Special care needs to be taken to handle the resv->adds_in_progress
> variable correctly. In the past, only 1 region would be added for every
> region_chg and region_add call. But now, each call may add multiple
> regions, so we can no longer increment adds_in_progress by 1 in region_chg,
> or decrement adds_in_progress by 1 after region_add or region_abort. Instead,
> region_chg calls add_reservation_in_range() to count the number of regions
> needed and allocates those, and that info is passed to region_add and
> region_abort to decrement adds_in_progress correctly.
> 
> We've also modified the assumption that region_add after region_chg
> never fails. region_chg now pre-allocates at least 1 region for
> region_add. If region_add needs more regions than region_chg has
> allocated for it, then it may fail.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

This is the same as the previous version.  My late comment was that we
need to rethink the disabling of region coalescing.  This is especially
important for private mappings where there will be one region for huge
page.  I know that you are working on this issue.  Please remove my
Reviewed-by: when sending out the next version.

Thanks,
-- 
Mike Kravetz
