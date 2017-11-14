From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Tue, 14 Nov 2017 12:49:44 -0500
Message-ID: <941d42e9-0696-a8f3-cda1-9be5b0303e6a@redhat.com>
References: <1507324230-22996-1-git-send-email-longman@redhat.com>
 <db119820-84d4-7ccb-e65a-966d2d7aaf02@redhat.com>
 <20171026143908.GD59538@devbig577.frc2.facebook.com>
 <2814be69-8dc1-b2f8-406e-cc4dda289d94@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <2814be69-8dc1-b2f8-406e-cc4dda289d94@redhat.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Mike Galbraith <efault@gmx.de>, Christian Brauner <christian.brauner@canonical.com>, =?UTF-8?Q?St=c3=a9phane_Graber?= <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>

On 10/26/2017 02:12 PM, Waiman Long wrote:
> On 10/26/2017 10:39 AM, Tejun Heo wrote:
>> Hello, Waiman.
>>
>> On Wed, Oct 25, 2017 at 11:50:34AM -0400, Waiman Long wrote:
>>> Ping! Any comment on this patch?
>> Sorry about the lack of response.  Here are my two thoughts.
>>
>> 1. I'm not really sure about the memory part.  Mostly because of the
>>    way it's configured and enforced is completely out of step with how
>>    mm behaves in general.  I'd like to get more input from mm folks on
>>    this.
> Yes, I also have doubt about which of the additional features are being
> actively used. That is why the current patch exposes only the memory_migrate
> flag in addition to the core *cpus and *mems control files. All the
> other v1 features are not exposed waiting for further investigation and
> feedback. One way to get more feedback is to have something that people
> can play with. Maybe we could somehow tag it as experimental so that we
> can change the interface later on, when necessary, if you have concern
> about setting the APIs in stone.
>
>> 2. I want to think more about how we expose the effective settings.
>>    Not that anything is wrong with what cpuset does, but more that I
>>    wanna ensure that it's something we can follow in other cases where
>>    we have similar hierarchical property propagation.
> Currently, the effective setting is exposed via the effective_cpus and
> effective_mems control files. Unlike other controllers that control
> resources, cpuset is unique in the sense that it is propagating
> hierarchical constraints on CPUs and memory nodes down the tree. I
> understand your desire to have a unified framework that can be applied
> to most controllers, but I doubt cpuset is a good model in this regard.

What do you think we can do for the 4.16 development cycle? I really
like to see some kind of at least experimental support for cpuset v2.
That may be the best way to gather feedback and decide what to do next.

Cheers,
Longman
