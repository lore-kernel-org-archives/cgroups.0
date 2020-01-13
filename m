From: Wei Yang <richardw.yang@linux.intel.com>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer list
Date: Mon, 13 Jan 2020 16:23:08 +0800
Message-ID: <20200113082308.GB27972@richard>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
 <20200111000352.efy6krudecpshezh@box>
 <20200112022858.GA17733@richard>
 <20200112225718.5vqzezfclacujyx3@box>
 <20200113004457.GA27762@richard>
 <20200113073614.jo2txcmazwlesl7b@box.shutemov.name>
Reply-To: Wei Yang <richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200113073614.jo2txcmazwlesl7b@box.shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, alexander.duyck@gmail.com, rientjes@google.com

On Mon, Jan 13, 2020 at 10:36:14AM +0300, Kirill A. Shutemov wrote:
>On Mon, Jan 13, 2020 at 08:44:57AM +0800, Wei Yang wrote:
>> >> It is possible two page in the same pgdate or memcg grab page lock
>> >> respectively and then access the same defer queue concurrently.
>> 
>> If my understanding is correct, you agree with my statement?
>
>Which one? If the one above then no. list_empty only accesses list_head
>for the struct page, not the queue.
>

Ah, I get your point.

>-- 
> Kirill A. Shutemov

-- 
Wei Yang
Help you, Help me
