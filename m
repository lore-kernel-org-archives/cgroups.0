From: Guru Prasad <gurupras-LjRBWs/Th6SVc3sceRu5cw@public.gmane.org>
Subject: Ignore cgroup while scheduling
Date: Fri, 17 Jun 2016 14:01:11 -0400
Message-ID: <CAMefCkAXEvs-4OzdBdhUfa3K+x3EJ8s-y_6pycibPdgHV0G9og@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

First off, I'm not sure if this is the right list to be posting on.
Sorry if it isn't.

I'm trying to modify the Linux scheduler by adding logic to
temporarily render a cgroup to be unschedulable.

One way to do this would be to take advantage of the fact that each
`cgroup` has a `tasks` file that is able to list all the PIDs of that
`cgroup`. Iterating over each task and setting its state to be blocked
should allow me to accomplish this, but this approach has a complexity
proportional to the size of the PID list.

Instead, since the scheduler has notion of groups, is it possible to
tell the scheduler to ignore one of the groups while looking for the
next task to run?


Regards
Guru
