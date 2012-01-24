From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC 0/4] per-namespace allowed filesystems list
Date: Tue, 24 Jan 2012 03:17:41 -0800
Message-ID: <m1boptjqne.fsf@fess.ebiederm.org>
References: <1327337772-1972-1-git-send-email-glommer@parallels.com>
	<m1vco2m0eh.fsf@fess.ebiederm.org> <4F1E886A.7000107@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F1E886A.7000107-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> (Glauber Costa's message of
	"Tue, 24 Jan 2012 14:31:06 +0400")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org, xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> writes:

> On 01/24/2012 04:04 AM, Eric W. Biederman wrote:
>> My first impression is that this looks like a hack to avoid finishing
>> the user namespace.
>
> See my reply to Al. So again, to avoid steering the discussions to details I
> myself don't consider central (since this is a first post anyway), let's focus
> on the /proc container case. It is a privileged user as far as the container
> goes, and we'd like to allow it to mount filesystems. But disallowing it to
> mount /proc, can guarantee that the user will be provided with a version of
> /proc that is safe, and that he can't escape this.

The key things are that to the rest of the system you want this user to
look like an unprivileged user.  Aka user namespace.

> Ideally, userspace wouldn't even get involved with this, and a process mounting
> /proc would see the right things, depending on where it came from. But turns out
> that the cgroups-controlled resources are a lot harder than the
> namespaces-controlled resources for this.

There are a couple of sides to this.

If you trust the root user in your container all you have to say is:
"Don't do that then."

There are things like /proc/cpuinfo that a lot of processes use to
figure out how many threads are wise to use.  That is a problem that
deserves a proper solution not a hack.

There are the global tunables under /proc like
/proc/sys/kernel/panic_on_oops that you don't want people touching.

There are potential security issues with people mounting block devices
when they can control the filesystem data before mounting the
filesystem.  That mostly deserves fixing the filesystems but in the
unprivileged mount context that probably deserves a whitelist.

Then the are problems with mounting cgroup filesystems inside of a
container, and wondering why they don't work.  That is a design
limitation in the cgroup filesystem and code that needs to be fixed.

Is there a case you are worried about that I have not covered?

Eric
