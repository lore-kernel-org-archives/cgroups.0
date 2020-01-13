From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v9 1/8] hugetlb_cgroup: Add hugetlb_cgroup reservation
 counter
Date: Mon, 13 Jan 2020 14:05:58 -0800
Message-ID: <a78595a8-448c-14bb-a54b-9be685f36388@oracle.com>
References: <20191217231615.164161-1-almasrymina@google.com>
 <817e2c4b-4c72-09f9-22ea-bbaf97584161@oracle.com>
 <CAHS8izNs24KOaRuQkVUuZZUh42rvkyBXJEJYrHNf9bLFnZEXCg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=bteqaIm33REwMocLQp5eXrWHmlZN7JbTCADnuM17JQ4=;
 b=icmnkw9K8LowJlmjZNZAJ6hy/yKzAOGnl8G9HV9FpnWaw2/+Bm5o5JI56Xh4scExmOoa
 NNlxoshBc8UPFAhtmxbKgCjuVUbmH8zCmeRKMJhZGc/4fA0ya7gzeGCUh/KrZ2Bj7Oqe
 2gjgUJKpPtK4j9nxCOYE5XqjAVAAvjJJayqkONUpL0g6AY37Fx5l76/0/oGD1QQjrMmo
 6vHutDBl9TXXQ6aW1c01hSYasayexIyrDVdUJ21bitn5OUUlcDv2VGGgnMQpqpExbi6W
 iBMFGPiuXGPxe2R78DLEw0UTI+QL7zeVbvvTs6jHSJEjM/8eFi4+ke2ZixsQ5S7D5v8A Pg== 
In-Reply-To: <CAHS8izNs24KOaRuQkVUuZZUh42rvkyBXJEJYrHNf9bLFnZEXCg@mail.gmail.com>
Content-Language: en-US
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>

On 1/13/20 1:03 PM, Mina Almasry wrote:
> On Mon, Jan 13, 2020 at 10:44 AM Mike Kravetz <mike.kravetz@oracle.com> wrote:
>>
>> On 12/17/19 3:16 PM, Mina Almasry wrote:
>>> - While usage_in_bytes tracks all *faulted* hugetlb memory,
>>> reservation_usage_in_bytes tracks all *reserved* hugetlb memory and
>>> hugetlb memory faulted in without a prior reservation.
>>
>> To me, this implies that 'faults without reservations' could cause
>> reservation usage to exceed reservation limit?  Or, does the faulting
>> process get a SIGBUS because of the reservation limit even though it
>> is not using reservations?
>>
>> We shall see in subsequent patches.
>>
> 
> The design we went with based on previous discussions is as follows:
> hugetlb pages faulted without a prior reservation get accounted at
> fault time, rather than reservation time, and if the fault causes the
> counter to cross the limit, the charge fails, hence the fault fails,
> hence the process gets sigbus'd.

Ok, sorry I did not recall the design discussion.

> This means that one counter I'm adding here can cover both use cases:
> if the userspace uses MAP_NORESERVE, then their memory is accounted at
> fault time and they may get sigbus'd.

Let's make sure this is clearly documented.  Someone could be surprised
if their application not using reserves gets a SIGBUS because there is a
reserve limit.
-- 
Mike Kravetz

