From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer list
Date: Mon, 6 Jan 2020 09:20:34 +0800
Message-ID: <20200106012034.GA15705@richard>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com>
 <alpine.DEB.2.21.2001031128200.160920@chino.kir.corp.google.com>
 <20200103233925.GA3678@richard>
 <alpine.DEB.2.21.2001031642530.92066@chino.kir.corp.google.com>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.2001031642530.92066@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, yang.shi@linux.alibaba.com

On Fri, Jan 03, 2020 at 04:44:59PM -0800, David Rientjes wrote:
>On Sat, 4 Jan 2020, Wei Yang wrote:
>
>> On Fri, Jan 03, 2020 at 11:29:06AM -0800, David Rientjes wrote:
>> >On Fri, 3 Jan 2020, Wei Yang wrote:
>> >
>> >> As all the other places, we grab the lock before manipulate the defer list.
>> >> Current implementation may face a race condition.
>> >> 
>> >> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
>> >> 
>> >> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
>> >> 
>> >> ---
>> >> I notice the difference during code reading and just confused about the
>> >> difference. No specific test is done since limited knowledge about cgroup.
>> >> 
>> >> Maybe I miss something important?
>> >
>> >The check for !list_empty(page_deferred_list(page)) must certainly be 
>> >serialized with doing list_del_init(page_deferred_list(page)).
>> >
>> 
>> Hi David
>> 
>> Would you mind giving more information? You mean list_empty and list_del_init
>> is atomic?
>> 
>
>I mean your patch is obviously correct :)  It should likely also have a 
>stable@vger.kernel.org # 5.4+

Ah, my poor English ;-)

>
>Acked-by: David Rientjes <rientjes@google.com>

-- 
Wei Yang
Help you, Help me
