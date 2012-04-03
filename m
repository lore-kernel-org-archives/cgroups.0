From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Tue, 3 Apr 2012 07:22:59 +0400
Message-ID: <4F7A6D13.4060704@parallels.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org> <20120330222936.GI28934@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120330222936.GI28934-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On 03/31/2012 02:29 AM, Tejun Heo wrote:
> On Wed, Mar 21, 2012 at 03:17:33PM -0700, Tejun Heo wrote:
>> and is also available in the following git branch.
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git cgroup-cftype
>
> Branch has been refreshed on top of the current mainline and with the
> updated patch.
>
> Thanks.
>
Do I need to send you a patch to remove memcg's populate on top of this ?
