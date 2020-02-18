From: Mike Kravetz <mike.kravetz-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v12 1/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Tue, 18 Feb 2020 11:14:21 -0800
Message-ID: <d498012a-ec87-ca48-ed78-5fcdaf372888@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211151906.637d1703e4756066583b89da@linux-foundation.org>
 <1582035660.7365.90.camel@lca.pw>
 <CAHS8izO5=vKs-v9v=Di3hQXBD41+_YpYarXn1yZu9YE6SR-i6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=klYs7sANTDBUGahPUju9sGWKYr/tKylftyYSkWKVd7M=;
 b=evNMlimVu3xmXlI/jjEVBPaZZEWMkPu5+xRAILOSZ2HHqMNX69dd4vUwzjS8x59DrKdd
 5nxBXGA3OxMdQin9eVnqgx0UqW+1nEMf8x/kDSi86SYett7WmGvjQZ3xU2lv8WtntjVE
 tPrSIL2BuuBGNJmoTMORRAExFtSh/hQyPT9m1wMTtokQ4/aR5VKRxcCbDqmEOcRMPnXu
 D6rahYOQtdo0znPDwFlsWuDUii+txSF/XOSXmCiu9lHDxNqfPTnOMaN78+EcuVzTeHaS
 2/rVylv79hPpyksaAUnl6ZKWAAQuolmrGuWMalYnfocc3uXd3cNr1f8QnOOGdNhGAkqN Sw== 
In-Reply-To: <CAHS8izO5=vKs-v9v=Di3hQXBD41+_YpYarXn1yZu9YE6SR-i6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/18/20 10:35 AM, Mina Almasry wrote:
> On Tue, Feb 18, 2020 at 6:21 AM Qian Cai <cai-J5quhbR+WMc@public.gmane.org> wrote:
>>
>> On Tue, 2020-02-11 at 15:19 -0800, Andrew Morton wrote:
>>> On Tue, 11 Feb 2020 13:31:20 -0800 Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>> [ 7933.806377][T14355] ------------[ cut here ]------------
>> [ 7933.806541][T14355] kernel BUG at mm/hugetlb.c:490!
>> VM_BUG_ON(t - f <= 1);
>> [ 7933.806562][T14355] Oops: Exception in kernel mode, sig: 5 [#1]
<snip>
> Hi Qian,
> 
> Yes this VM_BUG_ON was added by a patch in the series ("hugetlb:
> disable region_add file_region coalescing") so it's definitely related
> to the series. I'm taking a look at why this VM_BUG_ON fires. Can you
> confirm you reproduce this by running hugemmap06 from the ltp on a
> powerpc machine? Can I maybe have your config?
> 
> Thanks!

Hi Mina,

Looking at the region_chg code again, we do a

	resv->adds_in_progress += *out_regions_needed;

and then potentially drop the lock to allocate the needed entries.  Could
anopther thread (only adding reservation for a single page) then come in
and notice that there are not enough entries in the cache and hit the
VM_BUG_ON()?

-- 
Mike Kravetz
