From: Odin Ugedal <odin@ugedal.com>
Subject: Re: [PATCH 0/1] sched/fair: Fix unfairness caused by missing load decay
Date: Mon, 26 Apr 2021 18:33:19 +0200
Message-ID: <CAFpoUr1FgZhuBmor2vCFqC9z7wao+XSybPxJZKFfK-wvZOagCA@mail.gmail.com>
References: <20210425080902.11854-1-odin@uged.al> <CAKfTPtBHm+CjBTA614P9F2Vx3Bj7vv9Pt0CGFsiwqcrTFmKzjg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iYU3lzuppVdnEjezXpekUf6VbkMAR7oBXDRRTrFeQac=;
        b=jVGo1Sa7XqGytV84u+6tnD2lIJ5BIT515J9lY+r5N7g7tb6GMJ+I2jHONXmQ1B042J
         MZIDK39PFTvXH8G7ug+0q16h499bgj2xWLUx67SSayZtvHeSXcPspOGV8oXbGoMN/Icn
         kNZCA4EUvNoTTQkseZojDQ5Vr85IP+YEVPRSqchTyYRc05oJuMwWEyZko4nMI9yXXSkK
         ZtCurqx+TqG6unHNVxSRdgJSQ83pfp9V55jImmSlQW+3e0DwzdHwLG3KEXmYhTgCAyOk
         TrhzhZ9J2kX6TgupXj4JKis1fsvw/A4O/SynfoJA0iEXAE7miKKa+uvsbXUr8E9A/eA+
         p6Ug==
In-Reply-To: <CAKfTPtBHm+CjBTA614P9F2Vx3Bj7vv9Pt0CGFsiwqcrTFmKzjg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Odin Ugedal <odin@uged.al>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

Hi,


> Have you been able to reproduce this on mainline ?

Yes. I have been debugging and testing with v5.12-rc8. After I found
the suspected
commit in ~v4.8, I compiled both the v4.4.267 and v4.9.267, and was able to
successfully reproduce it on v4.9.267 and not on v4.4.267. It is also
reproducible
on 5.11.16-arch1-1 that my distro ships, and it is reproducible on all
the machines
I have tested.

> When running the script below on v5.12, I'm not able to reproduce your problem

v5.12 is pretty fresh, so I have not tested on anything before v5.12-rc8. I did
compile v5.12.0 now, and I am able to reproduce it there as well.

Which version did you try (the one for cgroup v1 or v2)? And/or did you try
to run the inspection bpftrace script? If you tested the cg v1
version, it will often
end up at 50/50, 51/49 etc., and sometimes 60/40+-, making it hard to
verify without inspection.

I have attached a version of the "sub cgroup" example for cgroup v1,
that also force
the process to start on cpu 1 (CPU_ME), and sends it over to cpu 0
(CPU) after attaching
to the new cgroup. That will make it evident each time. This example should also
always end up with 50/50 per stress process, but "always" ends up more
like 99/1.

Can you confirm if you are able to reproduce with this version?

--- bash start
CGROUP_CPU=/sys/fs/cgroup/cpu/slice
CGROUP_CPUSET=/sys/fs/cgroup/cpuset/slice
CGROUP_CPUSET_ME=/sys/fs/cgroup/cpuset/me
CPU=0
CPU_ME=1

function run_sandbox {
  local CG_CPUSET="$1"
  local CG_CPU="$2"
  local INNER_SHARES="$3"
  local CMD="$4"

  local PIPE="$(mktemp -u)"
  mkfifo "$PIPE"
  sh -c "read < $PIPE ; exec $CMD" &
  local TASK="$!"
  sleep .1
  mkdir -p "$CG_CPUSET"
  mkdir -p "$CG_CPU"/sub
  tee "$CG_CPU"/sub/cgroup.procs <<< "$TASK"
  tee "$CG_CPU"/sub/cpu.shares <<< "$INNER_SHARES"

  tee "$CG_CPUSET"/cgroup.procs <<< "$TASK"

  tee "$PIPE" <<< sandox_done
  rm "$PIPE"
}

mkdir -p "$CGROUP_CPU"
mkdir -p "$CGROUP_CPUSET"
mkdir -p "$CGROUP_CPUSET_ME"

tee "$CGROUP_CPUSET"/cpuset.cpus <<< "$CPU"
tee "$CGROUP_CPUSET"/cpuset.mems <<< "$CPU"

tee "$CGROUP_CPUSET_ME"/cpuset.cpus <<< "$CPU_ME"
echo $$ | tee "$CGROUP_CPUSET_ME"/cgroup.procs

run_sandbox "$CGROUP_CPUSET" "$CGROUP_CPU/cg-1" 50000 "stress --cpu 1"
run_sandbox "$CGROUP_CPUSET" "$CGROUP_CPU/cg-2" 2     "stress --cpu 1"

read # click enter to cleanup and stop all stress procs
killall stress
sleep .2
rmdir /sys/fs/cgroup/cpuset/slice/
rmdir /sys/fs/cgroup/cpu/slice/{cg-{1,2}{/sub,},}
--- bash end


Thanks
Odin
