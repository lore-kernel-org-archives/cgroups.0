From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: use trialcs->mems_allowed as a temp variable
Date: Mon, 10 Aug 2015 18:25:13 +0800
Message-ID: <55C87C09.7030207@huawei.com>
References: <1438870865-25468-1-git-send-email-alban@endocode.com>
 <20150807145907.GC14626@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150807145907.GC14626-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Iago Lopez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>

On 2015/8/7 22:59, Tejun Heo wrote:
> On Thu, Aug 06, 2015 at 04:21:05PM +0200, Alban Crequy wrote:
>> The comment says it's using trialcs->mems_allowed as a temp variable=
 but
>> it didn't match the code. Change the code to match the comment.
>>
>> This fixes an issue when writing in cpuset.mems when a sub-directory
>> exists: we need to write several times for the information to persis=
t:
>>
>> | root@alban:/sys/fs/cgroup/cpuset# mkdir footest9
>> | root@alban:/sys/fs/cgroup/cpuset# cd footest9
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# mkdir aa
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
>> |
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > cpuset.mems
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
>> |
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > cpuset.mems
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
>> | 0
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat aa/cpuset.mems
>> |
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > aa/cpuset.mems
>> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat aa/cpuset.mems
>> | 0
>> | root@alban:/sys/fs/cgroup/cpuset/footest9#
>>
>> This should help to fix the following issue in Docker:
>> https://github.com/opencontainers/runc/issues/133
>> In some conditions, a Docker container needs to be started twice in
>> order to work.
>>
>> Signed-off-by: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
>> Tested-by: Iago L=F3pez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
>
> Li?
>

Acked.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.17+
