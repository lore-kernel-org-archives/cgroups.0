From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 1/2] mm, memcontrol: Add memcg_iterate_all()
Date: Thu, 27 Jun 2019 17:03:06 -0400
Message-ID: <2213070d-34c3-4f40-d780-ac371a9cbbbe@redhat.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-2-longman@redhat.com>
 <20190627150746.GD5303@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627150746.GD5303@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Andrea Arcangeli <aarcange@redhat.com>

On 6/27/19 11:07 AM, Michal Hocko wrote:
> On Mon 24-06-19 13:42:18, Waiman Long wrote:
>> Add a memcg_iterate_all() function for iterating all the available
>> memory cgroups and call the given callback function for each of the
>> memory cgruops.
> Why is a trivial wrapper any better than open coded usage of the
> iterator?

Because the iterator is only defined within memcontrol.c. So an
alternative may be to put the iterator into a header file that can be
used by others. Will take a look at that.

Cheers,
Longman

