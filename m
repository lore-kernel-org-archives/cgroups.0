From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v11 4/9] hugetlb: disable region_add file_region
 coalescing
Date: Wed, 5 Feb 2020 18:12:26 -0800
Message-ID: <dd097d06-6ac8-08b6-d484-b6bfc5922a70@oracle.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-4-almasrymina@google.com>
 <cd457f80-2624-f524-36ce-f11b56b30f8a@oracle.com>
 <CAHS8izONQEGMHJVR3cpgbn+LbYZ9eYa4jNkOwkCYwpGBHXHm8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=t+D4j4G5Deohl2w/m6COIz7G6YZYqDMg9nUp9Tlbhvo=;
 b=GLUbw063qNnTe9MNJSAoROwPcPqU6HAKh1orO+BWPpD6eIjsQVck6D7zqlONFOiaYyJE
 GGmjrQn6hiROcgd5AVy9/B9cAoXN1QxpDOq0zrNVZtT0KHFJFxGtQpyeg/HIqWWslr/e
 MGXl42mjqO45bJ1ZQpR7iJTbcAmW31wRzB0dBl4PW9RdE+ZtgNJC0kzANN14hTOVDk1k
 QFnNcCnsFt2x4P2TJNg8scJJ8HAtY8fI3REREadJbO/ZIMu6N75GbD308ygqNRVT+iKL
 lGBoxImEM33KnYFAOUkdVrKNA/pZtBKOaDglf68XgTKUoHkU736sxUSQs3V0HZcr3G4y uQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=t+D4j4G5Deohl2w/m6COIz7G6YZYqDMg9nUp9Tlbhvo=;
 b=QWViX+zU3VnIerffikL7Bw22mgLz3+lBkq0VCDR/evI0ySEGyX0af/XeRFXR8OWiPjdf
 wn4zgpnfzygikGHBfLJxUH5HAXI/9ufXjNDqYjRt2lAglB4DMEZOwlfxL6LmSRNwOCuA
 qjSjGJt6yG0dcZyHotsOJTYrhni1aCECpSsTt4RFuBc2boNwfMDPaE1wOqU4hIvFliGd
 oQq4BXEvcRFsY1jwdHL8AOky7umgGkeqVkXsYc/VQ33BaIQJ+ZEPjMisc7IWfxocIOLj
 n2qWMOOIc00aZdDNLeppyXlixlsijIFHip49coLxOrB8TBZcC5Ui0av0y3vIaMuAAnI3 uA== 
In-Reply-To: <CAHS8izONQEGMHJVR3cpgbn+LbYZ9eYa4jNkOwkCYwpGBHXHm8Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/5/20 5:43 PM, Mina Almasry wrote:
> On Wed, Feb 5, 2020 at 3:57 PM Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>
>> On 2/3/20 3:22 PM, Mina Almasry wrote:
>>> A follow up patch in this series adds hugetlb cgroup uncharge info the
>>> file_region entries in resv->regions. The cgroup uncharge info may
>>> differ for different regions, so they can no longer be coalesced at
>>> region_add time. So, disable region coalescing in region_add in this
>>> patch.
>>>
>>> Behavior change:
>>>
>>> Say a resv_map exists like this [0->1], [2->3], and [5->6].
>>>
>>> Then a region_chg/add call comes in region_chg/add(f=0, t=5).
>>>
>>> Old code would generate resv->regions: [0->5], [5->6].
>>> New code would generate resv->regions: [0->1], [1->2], [2->3], [3->5],
>>> [5->6].
>>>
>>> Special care needs to be taken to handle the resv->adds_in_progress
>>> variable correctly. In the past, only 1 region would be added for every
>>> region_chg and region_add call. But now, each call may add multiple
>>> regions, so we can no longer increment adds_in_progress by 1 in region_chg,
>>> or decrement adds_in_progress by 1 after region_add or region_abort. Instead,
>>> region_chg calls add_reservation_in_range() to count the number of regions
>>> needed and allocates those, and that info is passed to region_add and
>>> region_abort to decrement adds_in_progress correctly.
>>>
>>> We've also modified the assumption that region_add after region_chg
>>> never fails. region_chg now pre-allocates at least 1 region for
>>> region_add. If region_add needs more regions than region_chg has
>>> allocated for it, then it may fail.
>>>
>>> Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> Reviewed-by: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> This is the same as the previous version.  My late comment was that we
>> need to rethink the disabling of region coalescing.  This is especially
>> important for private mappings where there will be one region for huge
>> page.  I know that you are working on this issue.  Please remove my
>> Reviewed-by: when sending out the next version.
>>
> 
> Yes to address that there is a new patch in the series, which
> re-enables the coalescing when the hugetlb cgroup uncharge info is the
> same. I guess it could be squashed with this one but I thought it was
> better to implement that patch on top of the patch that enabled shared
> accounting, because that is the patch that sets hugetlb cgroup info on
> the file region entries.
> 
> Let me know what you think.

Thanks, I saw there was an additional patch but I did not get to it yet.
I'll take a look and see how involved the changes are.

-- 
Mike Kravetz
