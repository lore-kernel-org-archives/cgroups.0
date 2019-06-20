From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH] slub: Don't panic for memcg kmem cache creation failure
Date: Thu, 20 Jun 2019 07:51:50 -0700
Message-ID: <e7ce6ea7-50fc-78ad-1394-4da11cba7ad3@intel.com>
References: <20190619232514.58994-1-shakeelb@google.com>
 <20190620055028.GA12083@dhcp22.suse.cz>
 <CALvZod4Fd5X91CzDLaVAvspQL-zoD7+9OGTiOro-hiMda=DqBA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALvZod4Fd5X91CzDLaVAvspQL-zoD7+9OGTiOro-hiMda=DqBA@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On 6/20/19 7:44 AM, Shakeel Butt wrote:
>> I am wondering whether SLAB_PANIC makes sense in general though. Why is
>> it any different from any other essential early allocations? We tend to
>> not care about allocation failures for those on bases that the system
>> must be in a broken state to fail that early already. Do you think it is
>> time to remove SLAB_PANIC altogether?
>>
> That would need some investigation into the history of SLAB_PANIC. I
> will look into it.

I think it still makes sense for things like the vma, filp, dentry
caches.  If we don't
have those, we can't even execve("/sbin/init") so we shouldn't even bother
continuing to boot.

Maybe we should turn off SLAB_PANIC behavior after boot.  We don't want
a silly driver or filesystem module that's creating slabs to be causing
panic()s.
