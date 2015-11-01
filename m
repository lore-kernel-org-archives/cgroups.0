From: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: piping core dump to a program escapes container
Date: Sun, 1 Nov 2015 21:25:40 +0100
Message-ID: <CAFLxGvz=d=4u7LZ_ZPES_MqfO0kWGxyWE9SPUuONjH9aM=dxFg@mail.gmail.com>
References: <CABAubTgj8+xngrvc7sNbYS_Hq+-rGAYCz0y433ByiZ45dZuT0w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=liEsBKLZ5rbCCAFGckdEztQyj/ApQ2cFUMxv34OjYq0=;
        b=RjXI3iPypvrlXmQS0BoBhp0nzBPz+fnxSXWCO+cLz8gwnQvcJ9VbzxBSLjS8iR06GA
         9dfjLG+jPjulVtLu5kyqUHlFhKMUxJS6vx/xdO1abRQcKD1B45nVO3NlRjqaZdH9iYqh
         tKLzNviGJOejfpoS9dRXuB6nupQb3ndgJgdFnw7RYiqB7K8c/goalfvC3W/iQ3hZhRxi
         xGMGlJt3BumrupK27bwX6PWgGtskThx5aTcmU/lW4vCeqYbwkiF5d6H2NFLer+lIW9c8
         +/A9atnesoD6RjPGNR7gr4u29KWpROrGKMT3P0tSQotvN//QPPVM0geNKOs0wfuF3Yur
         j6xQ==
In-Reply-To: <CABAubTgj8+xngrvc7sNbYS_Hq+-rGAYCz0y433ByiZ45dZuT0w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shayan Pooya <shayan-UQzSddOuLosdnm+yROfE0A@public.gmane.org>
Cc: cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

On Sat, Oct 24, 2015 at 11:54 PM, Shayan Pooya <shayan-UQzSddOuLosdnm+yROfE0A@public.gmane.org> wrote:
> I noticed the following core_pattern behavior in my linux box while
> running docker containers. I am not sure if it is bug, but it is
> inconsistent and not documented.
>
> If the core_pattern is set on the host, the containers will observe
> and use the pattern for dumping cores (there is no per cgroup
> core_pattern). According to core(5) for setting core_pattern one can:
>
> 1. echo "/tmp/cores/core.%e.%p" > /proc/sys/kernel/core_pattern
> 2. echo "|/bin/custom_core /tmp/cores/ %e %p " > /proc/sys/kernel/core_pattern
>
> The former pattern evaluates the /tmp/cores path in the container's
> filesystem namespace. Which means, the host does not see a core file
> in /tmp/cores.
>
> However, the latter evaluates the /bin/custom_core path in the global
> filesystem namespace. Moreover, if /bin/core decides to write the core
> to a path (/tmp/cores in this case as shown by the arg to
> custom_core), the path will be evaluated in the global filesystem
> namespace as well.
>
> The latter behaviour is counter-intuitive and error-prone as the
> container can fill up the core-file directory which it does not have
> direct access to (which means the core is also not accessible for
> debugging if someone only has access to the container).
>
> Currently, I work around this issue by detecting that the process is
> crashing from a container (by comparing the namespace pid to the
> global pid) and refuse to dump the core if it is from a container.

IMHO this is another example of the question whether a container should
be a full blown Linux system or not.
In your opinion containers should own core_pattern and be able to install
their own dump helpers.
Currently this is not the case as this is setting is only writable by
the global root.
Others might argue that containers are not a full virtual Linux with
all features and
an administrator may want to collect cores from all containers.

-- 
Thanks,
//richard
