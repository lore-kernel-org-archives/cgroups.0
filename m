From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Thu, 26 Oct 2017 14:12:01 -0400
Message-ID: <2814be69-8dc1-b2f8-406e-cc4dda289d94@redhat.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
 <db119820-84d4-7ccb-e65a-966d2d7aaf02@redhat.com>
 <20171026143908.GD59538@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171026143908.GD59538-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Christian Brauner <christian.brauner-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

On 10/26/2017 10:39 AM, Tejun Heo wrote:
> Hello, Waiman.
>
> On Wed, Oct 25, 2017 at 11:50:34AM -0400, Waiman Long wrote:
>> Ping! Any comment on this patch?
> Sorry about the lack of response.  Here are my two thoughts.
>
> 1. I'm not really sure about the memory part.  Mostly because of the
>    way it's configured and enforced is completely out of step with how
>    mm behaves in general.  I'd like to get more input from mm folks on
>    this.

Yes, I also have doubt about which of the additional features are being
actively used. That is why the current patch exposes only the memory_migrate
flag in addition to the core *cpus and *mems control files. All the
other v1 features are not exposed waiting for further investigation and
feedback. One way to get more feedback is to have something that people
can play with. Maybe we could somehow tag it as experimental so that we
can change the interface later on, when necessary, if you have concern
about setting the APIs in stone.

> 2. I want to think more about how we expose the effective settings.
>    Not that anything is wrong with what cpuset does, but more that I
>    wanna ensure that it's something we can follow in other cases where
>    we have similar hierarchical property propagation.

Currently, the effective setting is exposed via the effective_cpus and
effective_mems control files. Unlike other controllers that control
resources, cpuset is unique in the sense that it is propagating
hierarchical constraints on CPUs and memory nodes down the tree. I
understand your desire to have a unified framework that can be applied
to most controllers, but I doubt cpuset is a good model in this regard.

Cheers,
Longman
