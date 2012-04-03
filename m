From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCHSET] cgroup: cftype based file interface, take #2
Date: Wed, 4 Apr 2012 00:37:37 +0400
Message-ID: <4F7B5F91.7030405@parallels.com>
References: <1332368265-21586-1-git-send-email-tj@kernel.org> <20120330222936.GI28934@google.com> <4F7A6D13.4060704@parallels.com> <20120403184719.GB27794@dhcp-172-17-108-109.mtv.corp.google.com> <20120403185216.GD27794@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120403185216.GD27794-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On 04/03/2012 10:52 PM, Tejun Heo wrote:
> On Tue, Apr 03, 2012 at 11:47:19AM -0700, Tejun Heo wrote:
>> Hello, Glauber.
>>
>> On Tue, Apr 03, 2012 at 07:22:59AM +0400, Glauber Costa wrote:
>>> Do I need to send you a patch to remove memcg's populate on top of this ?
>>
>> populate is already gone.  My memory is a bit fuzzy now.  Can you spot
>> something broken / to be improved re. memcg cftypes in the current
>> cgroup/for-3.5 branch?
>
> Ugh... brainfart.  Please disregard the previous message.  Can you
> please resend the patches on top of cgroup/for-3.5 and use Li's new
> address - lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org ?
>
> Thanks.
>
All right.
I'll give a new test to make sure it is still okay, and send shortly
