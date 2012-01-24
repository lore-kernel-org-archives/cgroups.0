From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Tue, 24 Jan 2012 15:24:55 +0400
Message-ID: <4F1E9507.8020904@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com> <m1vco2m0eh.fsf@fess.ebiederm.org> <4F1E886A.7000107@parallels.com> <m1boptjqne.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <m1boptjqne.fsf@fess.ebiederm.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, serge@hallyn.com, daniel.lezcano@free.fr, pjt@google.com, mzxreary@0pointer.de, xemul@parallels.com, James.Bottomley@HansenPartnership.com, tj@kernel.org, eric.dumazet@gmail.com

On 01/24/2012 03:17 PM, Eric W. Biederman wrote:
> Glauber Costa<glommer@parallels.com>  writes:
>
>> On 01/24/2012 04:04 AM, Eric W. Biederman wrote:
>>> My first impression is that this looks like a hack to avoid finishing
>>> the user namespace.
>>
>> See my reply to Al. So again, to avoid steering the discussions to details I
>> myself don't consider central (since this is a first post anyway), let's focus
>> on the /proc container case. It is a privileged user as far as the container
>> goes, and we'd like to allow it to mount filesystems. But disallowing it to
>> mount /proc, can guarantee that the user will be provided with a version of
>> /proc that is safe, and that he can't escape this.
>
> The key things are that to the rest of the system you want this user to
> look like an unprivileged user.  Aka user namespace.
>
>> Ideally, userspace wouldn't even get involved with this, and a process mounting
>> /proc would see the right things, depending on where it came from. But turns out
>> that the cgroups-controlled resources are a lot harder than the
>> namespaces-controlled resources for this.
>
> There are a couple of sides to this.
>
> If you trust the root user in your container all you have to say is:
> "Don't do that then."

Of course he may not obey. And then mess up with the *other* containers 
in the system. (If he messes with himself, I don't care). Note that in 
this context, "messing" can be as simple as figuring out information 
that you'd not like the container to see.

> There are things like /proc/cpuinfo that a lot of processes use to
> figure out how many threads are wise to use.  That is a problem that
> deserves a proper solution not a hack.

Agreed. This can be either in the kernel or in userspace. If it is in 
userspace, maybe we'd like to guarantee that this view will be 
consistent, and not replaced by the systemwide version.

> There are the global tunables under /proc like
> /proc/sys/kernel/panic_on_oops that you don't want people touching.
>
> There are potential security issues with people mounting block devices
> when they can control the filesystem data before mounting the
> filesystem.  That mostly deserves fixing the filesystems but in the
> unprivileged mount context that probably deserves a whitelist.
>
> Then the are problems with mounting cgroup filesystems inside of a
> container, and wondering why they don't work.  That is a design
> limitation in the cgroup filesystem and code that needs to be fixed.
>
> Is there a case you are worried about that I have not covered?
>

The ones I've listed here in this mail, mostly. I am now wondering if 
Kirill has any around debugfs ?


