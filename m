From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v5 5/7] mm: rework non-root kmem_cache lifecycle
 management
Date: Tue, 28 May 2019 13:41:34 -0400
Message-ID: <518419c5-ee74-d9a1-c01c-f1a3306d2d34@redhat.com>
References: <20190521200735.2603003-1-guro@fb.com>
 <20190521200735.2603003-6-guro@fb.com>
 <20190528170828.zrkvcdsj3d3jzzzo@esperanza>
 <96b8a923-49e4-f13e-b1e3-3df4598d849e@redhat.com>
 <20190528173959.h4hq55b3ajlfpjrk@esperanza>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190528173959.h4hq55b3ajlfpjrk@esperanza>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, Shakeel Butt <shakeelb@google.com>, Christoph Lameter <cl@linux.com>, cgroups@vger.kernel.org

On 5/28/19 1:39 PM, Vladimir Davydov wrote:
> On Tue, May 28, 2019 at 01:37:50PM -0400, Waiman Long wrote:
>> On 5/28/19 1:08 PM, Vladimir Davydov wrote:
>>>>  static void flush_memcg_workqueue(struct kmem_cache *s)
>>>>  {
>>>> +	/*
>>>> +	 * memcg_params.dying is synchronized using slab_mutex AND
>>>> +	 * memcg_kmem_wq_lock spinlock, because it's not always
>>>> +	 * possible to grab slab_mutex.
>>>> +	 */
>>>>  	mutex_lock(&slab_mutex);
>>>> +	spin_lock(&memcg_kmem_wq_lock);
>>>>  	s->memcg_params.dying = true;
>>>> +	spin_unlock(&memcg_kmem_wq_lock);
>>> I would completely switch from the mutex to the new spin lock -
>>> acquiring them both looks weird.
>>>
>>>>  	mutex_unlock(&slab_mutex);
>>>>  
>>>>  	/*
>> There are places where the slab_mutex is held and sleeping functions
>> like kvzalloc() are called. I understand that taking both mutex and
>> spinlocks look ugly, but converting all the slab_mutex critical sections
>> to spinlock critical sections will be a major undertaking by itself. So
>> I would suggest leaving that for now.
> I didn't mean that. I meant taking spin_lock wherever we need to access
> the 'dying' flag, even if slab_mutex is held. So that we don't need to
> take mutex_lock in flush_memcg_workqueue, where it's used solely for
> 'dying' synchronization.

OK, that makes sense. Thanks for the clarification.

Cheers,
Longman

