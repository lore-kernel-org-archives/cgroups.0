From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v3 0/6] hugetlb_cgroup: Add hugetlb_cgroup reservation
 limits
Date: Tue, 3 Sep 2019 10:57:39 -0700
Message-ID: <cb7ebcce-05c5-3384-5632-2bbac9995c15@oracle.com>
References: <20190826233240.11524-1-almasrymina@google.com>
 <20190828112340.GB7466@dhcp22.suse.cz>
 <CAHS8izPPhPoqh-J9LJ40NJUCbgTFS60oZNuDSHmgtMQiYw72RA@mail.gmail.com>
 <20190829071807.GR28313@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=2CQvjcjn8S5qepJOVui7TagmqoVkFQxOyG/LeHJ4jns=;
 b=VIsu3iuVv3V2Rp/MY04+TEmNsQFl9ZZIxerTVvvOODw0AwKdlACPaGmAriaj5jWMBm7l
 cmsiNjxTyXAmhw9W9qJPqdALaf9wz6lloMeD3NcSoMsTiwv+A/tkftb5CE8iRbG1LC0u
 rCQny2Pp3b9WmLoct6jngYegMfAgh+Th8mu8lpUhb174FHU8QHqTUyaF1zZL0gh2++C0
 +Z+OZvxhLZVp0XwqvakZrbD+eTfuGDHQqXqBjpcMZAxGr/M/lCFpIsbVD13Ez+TbrmFI
 AWtSYUqk2UhJbQzyDWHlwyl78ImjmPY+z0FQ0RnjHlNd9FaaAaT47S+fe7Q3+14n7HtZ dA== 
In-Reply-To: <20190829071807.GR28313@dhcp22.suse.cz>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>, Mina Almasry <almasrymina@google.com>
Cc: shuah <shuah@kernel.org>, David Rientjes <rientjes@google.com>, Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Andrew Morton <akpm@linux-foundation.org>, khalid.aziz@oracle.com, open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

On 8/29/19 12:18 AM, Michal Hocko wrote:
> [Cc cgroups maintainers]
> 
> On Wed 28-08-19 10:58:00, Mina Almasry wrote:
>> On Wed, Aug 28, 2019 at 4:23 AM Michal Hocko <mhocko@kernel.org> wrote:
>>>
>>> On Mon 26-08-19 16:32:34, Mina Almasry wrote:
>>>>  mm/hugetlb.c                                  | 493 ++++++++++++------
>>>>  mm/hugetlb_cgroup.c                           | 187 +++++--
>>>
>>> This is a lot of changes to an already subtle code which hugetlb
>>> reservations undoubly are.
>>
>> For what it's worth, I think this patch series is a net decrease in
>> the complexity of the reservation code, especially the region_*
>> functions, which is where a lot of the complexity lies. I removed the
>> race between region_del and region_{add|chg}, refactored the main
>> logic into smaller code, moved common code to helpers and deleted the
>> duplicates, and finally added lots of comments to the hard to
>> understand pieces. I hope that when folks review the changes they will
>> see that! :)
> 
> Post those improvements as standalone patches and sell them as
> improvements. We can talk about the net additional complexity of the
> controller much easier then.

All such changes appear to be in patch 4 of this series.  The commit message
says "region_add() and region_chg() are heavily refactored to in this commit
to make the code easier to understand and remove duplication.".  However, the
modifications were also added to accommodate the new cgroup reservation
accounting.  I think it would be helpful to explain why the existing code does
not work with the new accounting.  For example, one change is because
"existing code coalesces resv_map entries for shared mappings.  new cgroup
accounting requires that resv_map entries be kept separate for proper
uncharging."

I am starting to review the changes, but it would help if there was a high
level description.  I also like Michal's idea of calling out the region_*
changes separately.  If not a standalone patch, at least the first patch of
the series.  This new code will be exercised even if cgroup reservation
accounting not enabled, so it is very important than no subtle regressions
be introduced.

-- 
Mike Kravetz
