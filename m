From: John Garcia <john.garcia@mesosphere.io>
Subject: Re: CGroups: idr_remove called for id=65536 which is not allocated.
Date: Wed, 13 Jul 2016 13:10:05 -0700
Message-ID: <CAO2SnQ-fEXH3xpAV3x61h1ewp8j8EYGPQTuhviE6=4Z2=KHvcA@mail.gmail.com>
References: <CAO2SnQ92vK2nn_8De_yq0vud=a+5k0WUGcx7jk3yHCRJ0MAsGQ@mail.gmail.com>
 <20160713152226.GC4065@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mesosphere.io; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=a1Xh80JcEzGRCXfvo9iuXSg8+6qeZFmPOEnEMV3qV+A=;
        b=uGRD3aMdkwAOEIV4fcw21ly0kDaLKIFIVd7gcmYm92m0gJM0rTijXfxnB47Y4CCgQx
         h+LzbTBBngEzmOzxMFDc3y07MQiLkRuNWipXmNifVKoF7qJiMqDQgpELMCOXC9tqOSD/
         c6oANltDJiV4v/wZI2MfEMYNCQwhaV88vpggI=
In-Reply-To: <20160713152226.GC4065@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>

Hi Tejun, thanks for the response!

It sounds like everything is good then, is it likely this will get
backported to the next LTS 4.4 kernel?

Thanks!
John

On Wed, Jul 13, 2016 at 8:22 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Wed, Jul 13, 2016 at 06:31:18AM -0700, John Garcia wrote:
>> Hi esteemed kernel devs! Please be sure to CC answers to me personally
>> so they're flagged for my attention.
>>
>> I've filed https://bugzilla.kernel.org/show_bug.cgi?id=124641 in
>> Bugzilla, so I'll try not to repeat too many key details here; GKH has
>> asked that I bring the conversation to email, LKML, and the cgroups
>> list.
>>
>> Long story short, we see the behavior described in this LKML thread
>> http://lkml.iu.edu/hypermail/linux/kernel/1606.2/00736.html and (we
>> think) addressed by the patch therein - memory cgroups don't seem to
>> be automatically garbage collected during runtime and must be manually
>> released to allow space for new cgroups after the 65336 limit is
>> reached. At this time, the only way we've found to release them is to
>
> It's not that memcg doesn't gc the dead csses but that the memory
> lying around keeps pinning the memcg struct down.  There's nothing
> wrong with it.  As soon as there's memory pressure, the memory will
> get reclaimed and the memcg structs will be freed.  The problem is
> caused by the memcg struct keeping pinning memcg id which is a pretty
> limited resource.  The above patch fixes the issue by the lifetime of
> decoupling memcg id from that of memcg struct.
>
>> send echo 1 > /proc/sys/vm/drop_caches
>> to the kernel. The title of this message is the dmesg line we
>> typically see in machines that have breached the limit, and are trying
>> in vain to remove a cgroup beyond the 65536 ceiling.
>
> The idr_remove message is from a bug in creation failure path.  It is
> harmless and removed by b00c52dae6d9 ("cgroup: remove redundant
> cleanup in css_create").
>
>> We've asked CoreOS to cut a build with the patch from LKML and we'll
>> test it shortly to see if it alleviates the problem. We'll update this
>> list with results of testing against that patch and also test against
>> a 4.6.x kernel as soon as possible. Let us know if you need the full
>> stack trace or other diagnostic info.
>
> With the patches backported, there shouldn't be any more issues.  If
> you encounter any more issues with it, please let us know.
>
> Thanks.
>
> --
> tejun



-- 
John Garcia
Technical Support Engineer
Mesosphere.io
