From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Tue, 24 Jan 2012 14:31:06 +0400
Message-ID: <4F1E886A.7000107@parallels.com>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com> <m1vco2m0eh.fsf@fess.ebiederm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <m1vco2m0eh.fsf-+imSwln9KH6u2/kzUuoCbdi2O/JbrIOy@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On 01/24/2012 04:04 AM, Eric W. Biederman wrote:
> Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>  writes:
>
>> This patch creates a list of allowed filesystems per-namespace.
>> The goal is to prevent users inside a container, even root,
>> to mount filesystems that are not allowed by the main box admin.
>>
>> My main two motivators to pursue this are:
>>   1) We want to prevent a certain tailored view of some virtual
>>      filesystems, for example, by bind-mounting files with userspace
>>      generated data into /proc. The ability of mounting /proc inside
>>      the container works against this effort, while disallowing it
>>      via capabilities would have the effect of disallowing other
>>      mounts as well.
>>
>> 2) Some filesystems are known not to behave well under a container
>>     environment. They require changes to work in a safe-way. We can
>>     whitelist only the filesystems we want.
>>
>> This works as a whitelist. Only filesystems in the list are allowed
>> to be mounted. Doing a blacklist would create problems when, say,
>> a module is loaded. The whitelist is only checked if it is enabled first.
>> So any setup that was already working, will keep working. And whoever
>> is not interested in limiting filesystem mount, does not need
>> to bother about it.
>
> My first impression is that this looks like a hack to avoid finishing
> the user namespace.
>
> This is a terrible way to go about implementing unprivileged mounts.
>
> If there are technical reasons why it is unsafe to mount filesystems
> that we need to whitelist/blacklist filesystems in the kernel where we
> can check things.
>
> Why in the world would anyone want the ability to not mount a specific
> filesystem type?

See my reply to Al. So again, to avoid steering the discussions to 
details I myself don't consider central (since this is a first post 
anyway), let's focus on the /proc container case. It is a privileged 
user as far as the container goes, and we'd like to allow it to mount 
filesystems. But disallowing it to mount /proc, can guarantee that the 
user will be provided with a version of /proc that is safe, and that he 
can't escape this.

Ideally, userspace wouldn't even get involved with this, and a process 
mounting /proc would see the right things, depending on where it came 
from. But turns out that the cgroups-controlled resources are a lot 
harder than the namespaces-controlled resources for this.

> Using netlink as an interface when you are talking filesystems to
> filesystem is pretty horrid.  Netlink is great for networking developers
> they get networking, but filesystem people understand filesystems and
> you want to use netlink?
>
Well, I am not doing it for filesystem people, but for people who are 
neither, aka,
whoever wants to use this interface. But that said, I don't want to keep 
the discussion around this. My main reason was to have a quick way to 
communicate this list to the kernel, so I could test it, and post a PoC 
for you guys to comment on. Even if everybody liked it, I was prepared 
from the start to redesign the interface.

