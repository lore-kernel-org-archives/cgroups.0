From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH v2 10/17] cgroup: Make debug cgroup support v2 and
 thread mode
Date: Thu, 18 May 2017 11:58:41 -0400
Message-ID: <3cb18ea6-fcc1-af92-3926-d65ae0a30b97@redhat.com>
References: <1494855256-12558-1-git-send-email-longman@redhat.com>
 <1494855256-12558-11-git-send-email-longman@redhat.com>
 <20170517214338.GG942@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 12DF4C04B93A
In-Reply-To: <20170517214338.GG942@htj.duckdns.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de

On 05/17/2017 05:43 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, May 15, 2017 at 09:34:09AM -0400, Waiman Long wrote:
>> Besides supporting cgroup v2 and thread mode, the following changes
>> are also made:
>>  1) current_* cgroup files now resides only at the root as we don't
>>     need duplicated files of the same function all over the cgroup
>>     hierarchy.
>>  2) The cgroup_css_links_read() function is modified to report
>>     the number of tasks that are skipped because of overflow.
>>  3) The relationship between proc_cset and threaded_csets are displayed.
>>  4) The number of extra unaccounted references are displayed.
>>  5) The status of being a thread root or threaded cgroup is displayed.
>>  6) The current_css_set_read() function now prints out the addresses of
>>     the css'es associated with the current css_set.
>>  7) A new cgroup_subsys_states file is added to display the css objects
>>     associated with a cgroup.
>>  8) A new cgroup_masks file is added to display the various controller
>>     bit masks in the cgroup.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> As noted before, please make it clear that this is a debug feature and
> not expected to be stable.  Also, I don't see why this and the
> previous two patches are in this series.  Can you please split these
> out to a separate patchset?
>
> Thanks.
>
Sure. I can separate out the debug code into a separate patchset. It is
just easier to manage as a single patchset than 2 separate ones.

Regards,
Longman

