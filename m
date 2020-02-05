From: Sandipan Das <sandipan@linux.ibm.com>
Subject: Re: [PATCH v11 8/9] hugetlb_cgroup: Add hugetlb_cgroup reservation
 tests
Date: Wed, 5 Feb 2020 18:12:37 +0530
Message-ID: <a980c9f7-2759-45a7-1add-89a390b79b39@linux.ibm.com>
References: <20200203232248.104733-1-almasrymina@google.com>
 <20200203232248.104733-8-almasrymina@google.com>
 <0fa5d77c-d115-1e30-cb17-d6a48c916922@linux.ibm.com>
 <CAHS8izPobKi_w8R4pTt_UyfxzBJJYuNUw+Z6hgFfvZ1Xma__YA@mail.gmail.com>
 <CAHS8izNmSYumXpYXT1d8tAm36=-BRjXqdCDjLB6UNMwn5xhPZg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHS8izNmSYumXpYXT1d8tAm36=-BRjXqdCDjLB6UNMwn5xhPZg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>, shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

Hi,

On 05/02/20 4:03 am, Mina Almasry wrote:
> On Tue, Feb 4, 2020 at 12:36 PM Mina Almasry <almasrymina@google.com> wrote:
>>
>> So the problem in this log seems to be that this log line is missing:
>>     echo Waiting for hugetlb memory to reach size $size.
>>
>> The way the test works is that it starts a process that writes the
>> hugetlb memory, then it *should* wait until the memory is written,
>> then it should record the cgroup accounting and kill the process. It
>> seems from your log that the wait doesn't happen, so the test
>> continues before the background process has had time to write the
>> memory properly. Essentially wait_for_hugetlb_memory_to_get_written()
>> never gets called in your log.
>>
>> Can you try this additional attached diff on top of your changes? I
>> attached the diff and pasted the same here, hopefully one works for
>> you:
>> ...
> 
> I got my hands on a machine with 16MB default hugepage size and
> charge_reserved_hugetlb.sh passes now after my changes. Please let me
> know if you still run into issues.
> 

With your updates, the tests are passing. Ran the tests on a ppc64 system
that uses radix MMU (2MB hugepages) and everything passed there as well.

- Sandipan

