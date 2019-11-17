From: Wenkuan Wang <wwk0817@gmail.com>
Subject: Re: [PATCH v8 5/9] hugetlb: disable region_add file_region coalescing
Date: Sun, 17 Nov 2019 19:03:16 +0800
Message-ID: <010d5a90-3ebf-30e5-8829-a61f01b6f620@gmail.com>
References: <20191030013701.39647-1-almasrymina@google.com>
 <20191030013701.39647-5-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oidSitOSx3wz/zOT9+cz4soIOB6y/ZqJ5xkv2u37mMg=;
        b=jJEJMNfRpHtXmJckbTZB9ZNHCq2xiXBw90gY9gIbEXxRovl7hLntxcbbaAJAf2ud+b
         MXSNvcdZDb+0nshW/ucfoHsxQ8QRBHxgRSL5szZH88Wyc09iVGespARjnFZ+xtCUCsX4
         QeAd9DLUmgCNls3d3COIAwF12Lgg3kyUymoZejLgB9wVH8w6evTKORKdk+n2d5Jftvcc
         FPi2UbmDvlAMhMpG6uftA5lkaa/oMW3HLrOKZHXfX9i8BLGQF/9S3WakXBP3t1bJi7+u
         HaMNelmGG9FA6kvTeLFdgDEtFNwk5rBux4rm6+hvJms+0BAmsI1d43UY0aYqS79CZYDL
         tCeg==
In-Reply-To: <20191030013701.39647-5-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, mike.kravetz@oracle.com
Cc: shuah@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com



On 10/30/19 9:36 AM, Mina Almasry wrote:
> /* Must be called with resv->lock held. Calling this with count_only == true
> * will count the number of pages to be added but will not modify the linked
> - * list.
> + * list. If regions_needed != NULL and count_only == true, then regions_needed
> + * will indicate the number of file_regions needed in the cache to carry out to
> + * add the regions for this range.
> */
> static long add_reservation_in_range(struct resv_map *resv, long f, long t,

Hi Mina,

Would you please share which tree this patch set used? this patch 5/9 can't be
applied with Linus's tree and add_reservation_in_range can't be found.

Thanks
Wenkuan

> - bool count_only)
> + long *regions_needed, bool count_only)
> {
> - long chg = 0;
> + long add = 0;
> struct list_head *head = &resv->regions;
> + long last_accounted_offset = f;
> struct file_region *rg = NULL, *trg = NULL, *nrg = NULL;
> - /* Locate the region we are before or
