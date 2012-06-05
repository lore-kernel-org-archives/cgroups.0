From: Daniel Lezcano <daniel.lezcano-GANU6spQydw@public.gmane.org>
Subject: Re: [PATCH] allow a task to join a pid namespace
Date: Tue, 05 Jun 2012 11:30:08 +0200
Message-ID: <4FCDD1A0.7040402@free.fr>
References: <1338816828-25312-1-git-send-email-glommer@parallels.com> <20120604165117.GA13091@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120604165117.GA13091-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kir-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 06/04/2012 06:51 PM, Oleg Nesterov wrote:
> On 06/04, Glauber Costa wrote:
>>
>> Currently, it is possible for a process  to join existing
>> net, uts and ipc namespaces. This patch allows a process to join an
>> existing pid namespace as well.
> 
> I can't understand this patch... but probably I missed something,
> I never really understood setns.

Hi Oleg,

let me clarify why is needed setns. In the world of container, setns
allows to administrate the container from outside. One good example is
to shutdown the container. The users setup their hosts with the init's
services to startup the containers when the system starts, but they have
no way to invoke 'shutdown' from inside the container when the system
goes down except doing some trick with the signals. The setns syscall
with the pid namespace support will allow to do that.

Also a complete setns support will allow to write some administrative
tools to have a global view of the different separated resources running
in several containers.

For example, if you are the administrator of the host and you have
hundred of containers running on it, you can use setns to run netstat
within each container and build a view of the different network stack.
The same applies for 'ps' or 'top'.

Without setns, things are much more complicated and in some cases,
impossible. For instance, you can run a daemon inside the container,
send command to it and redirect its output to the fifo  but that
increase the number of processes and has some limitations. Also that
means the command you want to run is present in the container's FS.

The setns syscall is highly needed for the VRF, where a single process
can handle thousand of network namespaces and switch from a network
namespace to another network namespace with one syscall. The usage of
the file descriptors pins the namespace and prevent it from being
destroyed when switching from one namespace to another.

In other words, +1 for pid ns support with setns :)

  -- Daniel
