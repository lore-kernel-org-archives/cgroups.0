From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv9 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 3 Mar 2016 08:19:07 +0530
Message-ID: <CAG53R5VYnTMzG4DchY2DKgveeeXbKcjUWQpOOjCNQuY-f7g9bg@mail.gmail.com>
References: <1456859137-13646-1-git-send-email-pandit.parav@gmail.com>
	<1456859137-13646-2-git-send-email-pandit.parav@gmail.com>
	<20160302173949.GG29826@mtj.duckdns.org>
	<CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=BdFkWygNfygPn8rGSG8nev3E9SISKkMfHRc8W6NhUjM=;
        b=FOeMT0qTEoOPjTmyEcYwP8D3xMuh4w87cVDxpePCjlge9O74tCX8NOrGB1u4Sy2FMw
         NLQsS2jFCGqH04tI/mzFCUrb7Q4Brih/V9i/od36ZrH/MXka6A2DYZSXapD16bk1XMWI
         bWk5pCnyU4SPZN+aBQYy97UTt3X0lmFHtVsx5V9I9RishOfy0bB5qaZhygEYhOGbtgfC
         cZae1v0wn9V9LCOBuuS6tEqOvoCjER7II2/gvkwPx+V4NhaYegqidZHcg9tKTaw7Cs42
         NOlkvawhfdvJ0YmwdX5+xY7bX6xxUddhyeEvsRHF81k+rulznV8xUy7OTP5f+V9IBdK/
         hTAw==
In-Reply-To: <CAG53R5UAmTP9-m77-j2tPGZ+z8AicuVvUB_++cRUbQY-EwaBYw@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hi Tejun, Haggai,

On Thu, Mar 3, 2016 at 1:28 AM, Parav Pandit <pandit.parav@gmail.com> wrote:
>>> +     rpool->refcnt--;
>>> +     if (rpool->refcnt == 0 && rpool->num_max_cnt == pool_info->table_len) {
>>
>> If the caller charges 2 and then uncharges 1 two times, the refcnt
>> underflows?  Why not just track how many usages are zero?
>>
> This is certainly must fix bug. Changed refcnt to usage_sum and changed to do
> usage_sum -= num during uncharging
> and
> usage_sum += num during charing.

This is not sufficient as css_get() and put are done only once per
call, which leads to similar problem as of refcnt.
As I think more, I realised that this particular test is missing that
resulted in this related bug, I realize that we don't have use case to
have "num" field from the IB stack side.
For bulk free IB stack will have to keep track of different or same
rdmacg returned values to call uncharge() with right number of
resources, all of that complexity just doesn't make sense and not
required.
So as first step to further simplify this, I am removing "num" input
field from charge and uncharge API.
