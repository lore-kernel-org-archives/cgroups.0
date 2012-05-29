From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 2/5] account guest time per-cgroup as well.
Date: Tue, 29 May 2012 14:34:55 +0400
Message-ID: <4FC4A64F.3040707@parallels.com>
References: <1334010315-4453-1-git-send-email-glommer@parallels.com> <1334010315-4453-3-git-send-email-glommer@parallels.com> <CAPM31RLwY4d-Ng3-T+-1eLxuZxr8wbdC_+sDQbJQXuqEfe9tfg@mail.gmail.com> <4FC37D01.7080704@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC37D01.7080704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lxc-users-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org

On 05/28/2012 05:26 PM, Glauber Costa wrote:
>
> I plan to measure this today, but an extra branch cost for the common
> case of a task in the root cgroup + O(depth) for tasks inside cgroups
> may be acceptable, given the simplification it brings.
>
> Let me know what you think.

Numbers:

benchmark is hackbench -pipe 1 thread 4000

task sitting in the root cgroup
================================
Without this patch:
4.857700 (0.69 %)
With this patch:
4.828733 (0.55 %)

Difference between them: 0.59 %, very close to the standard deviation, 
no real difference.

task sitting in a 3-level cgroup
=================================
Without this patch
5.120867 (1.60 %)
With this patch
5.126267 (1.30 %)

Difference between them: 0.10 %, way within the standard deviation


Task sitting in a level-30 cgroup: (total crazy)
=================================================
Without this patch:
8.829385 (2.63 %)
With this patch:
9.347846 (2.25 %)

Difference is about 5.8 %, way out of the standard deviation, so it is 
really worse. But who uses 30-level hierarchy?

I believe depth-3 is close to a practical worst case, for the very 
majority of the workloads out there. Therefore I don't see the loop here 
as a big problem. It does degrade, but not in any use case that matters.
