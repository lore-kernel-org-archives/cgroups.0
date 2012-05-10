From: Andre Nathan <andre-K36Kqf6HJK439yzSjRtAkw@public.gmane.org>
Subject: About cgroup memory limits
Date: Thu, 10 May 2012 18:38:43 -0300
Message-ID: <1336685923.15687.1.camel@andre>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: andre-K36Kqf6HJK439yzSjRtAkw@public.gmane.org, michel-K36Kqf6HJK439yzSjRtAkw@public.gmane.org

Hello

I'm doing some tests with LXC and how it interacts with the memory
cgroup limits, more specifically the memory.limit_in_bytes control file.

Am I correct in my understanding of the memory cgroup documentation[1]
that the limit set in memory.limit_in_bytes is applied to the sum of the
fields 'cache', 'rss' and 'mapped_file' in the memory.stat file?

I am also trying to understand the values reported in memory.stat when
compared to the statistics in /proc/$PID/statm.

Below is the sum of each field in /proc/$PID/statm for every process
running inside a test container, converted to bytes:

       size  resident     share     text  lib       data  dt
  897208320  28741632  20500480  1171456    0  170676224   0

Compare this with the usage reports from memory.stat (fields total_*,
hierarchical_* and pg* omitted):

cache                     16834560
rss                       8192000
mapped_file               3743744
swap                      0
inactive_anon             0
active_anon               8192000
inactive_file             13996032
active_file               2838528
unevictable               0

Is there a way to reconcile these numbers somehow? I understand that the
fields from the two files represent different things. What I'm trying to
do is to combine, for example, the fields from memory.stat to
approximately reach what is displayed by statm.

Thank you in advance,
Andre

[1] http://www.kernel.org/doc/Documentation/cgroups/memory.txt


