From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 00/38] Replace deprecated CPU-hotplug
Date: Tue,  3 Aug 2021 16:15:43 +0200
Message-ID: <20210803141621.780504-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-acpi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628000193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qkfc7lxCqn4p3B20wjfjiLsyLpuZIa2kIlbDitBY8sw=;
        b=fStBYY9cDOofnMkMc6JUcZVYcNWx/eg2N05Pb/o7ef6JJTcTG48t+GioJgBl+eXKMJGEgi
        TVCeDR+EwHJjgdulnpLwVy12sseYnaixefw5o14vk+2PAOm/LUlJHLssIOZ+nJyuRxaM3r
        fCCG5ZeBAdz/Q3kIzOJQstWW7ST+mFehWQwEJk+hKZizcoepZD/zOgz+f7GO7oZ2MtK2DY
        wm7slubFVtLqvtY6o7cEl9ZIw3mvJ35go7HuaiPxyi+ESejsT+e0qaP6D0Fis4EUqsKcRu
        JGNGT0BYA9PAUGHVfsb3cVOtZwFCr59O6V6ObVy+T4OF395mknhLgwpLJFiGUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628000193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Qkfc7lxCqn4p3B20wjfjiLsyLpuZIa2kIlbDitBY8sw=;
        b=pGmFmcj1u+vX59p9gWCClfCslb9a1WxY2Pwa8q+HwkfzdAY6X/r9JgYaxIXaCJOpPNDW2W
        rceMZSe2cSwuwVDA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Amit Kucheria <amitk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ben Segall <bsegall@google.com>, Borislav Petkov <bp@alien8.de>, cgroups@vger.kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>, coresight@lists.linaro.org, Daniel Bristot de Oliveira <bristot@redhat.com>, Daniel Jordan <daniel.m.jordan@oracle.com>, Daniel Lezcano <daniel.lezcano@linaro.org>, Dave Hansen <dave.hansen@linux.intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "David S. Miller" <dave>

This is a tree wide replacement of the deprecated CPU hotplug functions
which are only wrappers around the actual functions.

Each patch is independent and can be picked up by the relevant maintainer.

Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Amit Kucheria <amitk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: cgroups@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: coresight@lists.linaro.org
Cc: Daniel Bristot de Oliveira <bristot@redhat.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Gonglei <arei.gonglei@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Karol Herbst <karolherbst@gmail.com>
Cc: Karsten Graul <kgraul@linux.ibm.com>
Cc: kvm-ppc@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-crypto@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-edac@vger.kernel.org
Cc: linux-hwmon@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-pm@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-raid@vger.kernel.org
Cc: linux-s390@vger.kernel.org
Cc: live-patching@vger.kernel.org
Cc: Mark Gross <mgross@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: netdev@vger.kernel.org
Cc: nouveau@lists.freedesktop.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Paalanen <ppaalanen@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: platform-driver-x86@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: rcu@vger.kernel.org
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Song Liu <song@kernel.org>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Steve Wahl <steve.wahl@hpe.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: virtualization@lists.linux-foundation.org
Cc: x86@kernel.org
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Zhang Rui <rui.zhang@intel.com>

Sebastian

