From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/4] cgroup bpf auto-detachment
Date: Fri, 24 May 2019 21:40:39 +0000
Message-ID: <20190524214032.GA15067@castle>
References: <20190523194532.2376233-1-guro@fb.com>
 <20190524210321.tzpt7ilaasaagtou@ast-mbp.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=833M6gQ2Lc6X7v1EvYyqYf2ze/A0atFyhkbjTieKZoY=;
 b=AK5XWV5G4EOoxW13QnMyCxFvplkw89yIBF8aaWwGNHUkB/h/YN/r3hqiU5seg7efJCvJ
 eNNLoxohr6OGJDwjdpsziYsBkDKIwuKsGXEek9C14sq9b48iEUQjCTo+mpgbQHjVrFBO
 3tKMVGTPPlchFfdrifvYlY1iY/8vqqCZWs8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=833M6gQ2Lc6X7v1EvYyqYf2ze/A0atFyhkbjTieKZoY=;
 b=qSIuk9ZG7+33t1+eALaCAnwb3/BeLYrYju9ZRKg6Ep9PrY+XHSI3gYgPgWyK9xhWZ9qv399AUOiopPgPr7C56vlb2LFzOr5uzWvbREfEpOFvC0aFmygiHf5Jhuewcbz2b9wOW4sfJh4kTPYElFoQNN4j4igSAXM4hNEGF9PzS8U=
In-Reply-To: <20190524210321.tzpt7ilaasaagtou@ast-mbp.dhcp.thefacebook.com>
Content-Language: en-US
Content-ID: <4B9034D8D4595A4EAB3AEF55618767B8@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Yonghong Song <yhs@fb.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, May 24, 2019 at 02:03:23PM -0700, Alexei Starovoitov wrote:
> On Thu, May 23, 2019 at 12:45:28PM -0700, Roman Gushchin wrote:
> > This patchset implements a cgroup bpf auto-detachment functionality:
> > bpf programs are detached as soon as possible after removal of the
> > cgroup, without waiting for the release of all associated resources.
>=20
> The idea looks great, but doesn't quite work:
>=20
> $ ./test_cgroup_attach
> #override:PASS
> [   66.475219] BUG: sleeping function called from invalid context at ../i=
nclude/linux/percpu-rwsem.h:34
> [   66.476095] in_atomic(): 1, irqs_disabled(): 0, pid: 21, name: ksoftir=
qd/2
> [   66.476706] CPU: 2 PID: 21 Comm: ksoftirqd/2 Not tainted 5.2.0-rc1-002=
11-g1861420d0162 #1564
> [   66.477595] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIO=
S 1.11.0-2.el7 04/01/2014
> [   66.478360] Call Trace:
> [   66.478591]  dump_stack+0x5b/0x8b
> [   66.478892]  ___might_sleep+0x22f/0x290
> [   66.479230]  cpus_read_lock+0x18/0x50
> [   66.479550]  static_key_slow_dec+0x41/0x70
> [   66.479914]  cgroup_bpf_release+0x1a6/0x400
> [   66.480285]  percpu_ref_switch_to_atomic_rcu+0x203/0x330
> [   66.480754]  rcu_core+0x475/0xcc0
> [   66.481047]  ? switch_mm_irqs_off+0x684/0xa40
> [   66.481422]  ? rcu_note_context_switch+0x260/0x260
> [   66.481842]  __do_softirq+0x1cf/0x5ff
> [   66.482174]  ? takeover_tasklets+0x5f0/0x5f0
> [   66.482542]  ? smpboot_thread_fn+0xab/0x780
> [   66.482911]  run_ksoftirqd+0x1a/0x40
> [   66.483225]  smpboot_thread_fn+0x3ad/0x780
> [   66.483583]  ? sort_range+0x20/0x20
> [   66.483894]  ? __kthread_parkme+0xb0/0x190
> [   66.484253]  ? sort_range+0x20/0x20
> [   66.484562]  ? sort_range+0x20/0x20
> [   66.484878]  kthread+0x2e2/0x3e0
> [   66.485166]  ? kthread_create_worker_on_cpu+0xb0/0xb0
> [   66.485620]  ret_from_fork+0x1f/0x30
>=20
> Same test runs fine before the patches.
>=20

Ouch, static_branch_dec() might block, so it's not possible to call it from
percpu ref counter release callback. It's not what I expected, tbh.

Good catch, thanks!
