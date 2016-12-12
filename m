From: =?UTF-8?B?SmVzw7pzIFJvZHLDrWd1ZXogQWNvc3Rh?= 
        <jesus.rodriguez.acosta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: WARNING: CPU: 3 PID: 1034 at kernel/cgroup.c:492
Date: Mon, 12 Dec 2016 11:09:07 +0000
Message-ID: <CAH=7=un56LL12Meu0j+6+ZRcdsnUHomfDLuq=raC6ZtQEwLqTA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=R2nku5HItBvi8IVCjHF0qVWoeXN7Jok+LtMix09fLI0=;
        b=QpR0oLWO2od2Wl80GniqPEJeVEplt+PnGsFlO4OtaaCZvPcFkzZjH0lSSDd37iikTc
         31LcDQFQhIBUo7IDMscix1tQ9yUINbaj+qaYxPIoE6hjrlN9oYUuLiXvflgN2G9uCS9e
         oBQo7zX3uahHuq7PVu3NTCE0SI2AhlED9mulmQ4dh0fw0HQfEd/h+4m3rtmetbqDBeJG
         HKBIpPE3kMQfUpoBSBL3RVJ9MUU5Gq1SvWFdLxCg79q+aEfFQiHgjFkY8UnDRQ/yt5bw
         Ta5RL9mqHVzVU3cUab7r6poZc9mJEBSm/XANWddTURclFd11+jcUekv69xVel/6FOpmM
         lUYg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since few days ago (maybe kernel version 4.8.11, but not sure), a
warning with a call trace is appearing from time to time in the system
log, I guess when starting up a KVM machine.

The system looks fine, and if you need more information, just let me
know and I'll try to provide everything requested.

The log below is from the recently released 4.9.0:


Dec 12 10:02:58 desktop kernel: ------------[ cut here ]------------
Dec 12 10:02:58 desktop kernel: WARNING: CPU: 3 PID: 1034 at
kernel/cgroup.c:492 cgroup_get+0x55/0x70
Dec 12 10:02:58 desktop kernel: Modules linked in: vhost_net vhost
macvtap macvlan algif_skcipher af_alg xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf
Dec 12 10:02:58 desktop kernel:  ablk_helper snd_pcm mei_me e1000e
cryptd serio_raw drm lpc_ich firewire_core mei i2c_i801 snd_timer
crc_itu_t ptp pp
Dec 12 10:02:58 desktop kernel: CPU: 3 PID: 1034 Comm: vhost-1020
Tainted: P           OE   4.9.0-gentoo_kdbus-bfq-300Hz #1
Dec 12 10:02:58 desktop kernel: Hardware name: System manufacturer
System Product Name/P9X79 WS, BIOS 4601 03/05/2014
Dec 12 10:02:58 desktop kernel:  0000000000000000 ffffffff812b06cd
0000000000000000 0000000000000000
Dec 12 10:02:58 desktop kernel:  ffffffff8105134a ffff880427672400
ffff8804216a8780 ffff880428341708
Dec 12 10:02:58 desktop kernel:  ffff8803c79c6f00 ffff88043fcc3ab7
0000000000000000 ffffffff810c5ab5
Dec 12 10:02:58 desktop kernel: Call Trace:
Dec 12 10:02:58 desktop kernel:  <IRQ>
Dec 12 10:02:58 desktop kernel:  [<ffffffff812b06cd>] ? dump_stack+0x46/0x5=
9
Dec 12 10:02:58 desktop kernel:  [<ffffffff8105134a>] ? __warn+0xba/0xe0
Dec 12 10:02:58 desktop kernel:  [<ffffffff810c5ab5>] ? cgroup_get+0x55/0x7=
0
Dec 12 10:02:58 desktop kernel:  [<ffffffff814ff566>] ?
sk_clone_lock+0x2d6/0x380
Dec 12 10:02:58 desktop kernel:  [<ffffffff8155612c>] ?
inet_csk_clone_lock+0xc/0xb0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8156fb79>] ?
tcp_create_openreq_child+0x19/0x490
Dec 12 10:02:58 desktop kernel:  [<ffffffff8156ddee>] ?
tcp_v4_syn_recv_sock+0x3e/0x2e0
Dec 12 10:02:58 desktop kernel:  [<ffffffff81570384>] ?
tcp_check_req+0x394/0x4e0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8156ca2b>] ?
tcp_v4_inbound_md5_hash+0x5b/0x1a0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8156f19b>] ? tcp_v4_rcv+0x49b/0x=
c40
Dec 12 10:02:58 desktop kernel:  [<ffffffffa016d58a>] ?
nf_nat_ipv4_fn+0x5a/0x1d0 [nf_nat_ipv4]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa015e2ef>] ?
ipv4_confirm+0x6f/0xe0 [nf_conntrack_ipv4]
Dec 12 10:02:58 desktop kernel:  [<ffffffff8154ac1f>] ?
ip_local_deliver_finish+0x8f/0x1e0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8154b273>] ?
ip_local_deliver+0x43/0x100
Dec 12 10:02:58 desktop kernel:  [<ffffffff8154ab90>] ?
inet_del_offload+0x30/0x30
Dec 12 10:02:58 desktop kernel:  [<ffffffff8154b5b2>] ? ip_rcv+0x282/0x3a0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8154ad70>] ?
ip_local_deliver_finish+0x1e0/0x1e0
Dec 12 10:02:58 desktop kernel:  [<ffffffff81512333>] ?
__netif_receive_skb_core+0x2a3/0x9f0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8151478f>] ?
netif_receive_skb_internal+0x1f/0x90
Dec 12 10:02:58 desktop kernel:  [<ffffffffa0116ec8>] ?
br_pass_frame_up+0xa8/0x150 [bridge]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa0116da0>] ?
br_port_flags_change+0x10/0x10 [bridge]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa0117131>] ?
br_handle_frame_finish+0x1c1/0x4f0 [bridge]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa0117601>] ?
br_handle_frame+0x161/0x2f0 [bridge]
Dec 12 10:02:58 desktop kernel:  [<ffffffff815123ba>] ?
__netif_receive_skb_core+0x32a/0x9f0
Dec 12 10:02:58 desktop kernel:  [<ffffffff81078a94>] ?
cpu_load_update+0xb4/0xc0
Dec 12 10:02:58 desktop kernel:  [<ffffffff810a710f>] ?
run_timer_softirq.part.23+0x8f/0xa0
Dec 12 10:02:58 desktop kernel:  [<ffffffff81515e97>] ?
process_backlog+0x97/0x130
Dec 12 10:02:58 desktop kernel:  [<ffffffff81515cf7>] ?
net_rx_action+0x1a7/0x2b0
Dec 12 10:02:58 desktop kernel:  [<ffffffff81055963>] ? __do_softirq+0xd3/0=
x1c0
Dec 12 10:02:58 desktop kernel:  [<ffffffff816060bc>] ?
do_softirq_own_stack+0x1c/0x30
Dec 12 10:02:58 desktop kernel:  <EOI>
Dec 12 10:02:58 desktop kernel:  [<ffffffff8105562a>] ?
do_softirq.part.16+0x2a/0x30
Dec 12 10:02:58 desktop kernel:  [<ffffffff81511fbc>] ? netif_rx_ni+0x3c/0x=
50
Dec 12 10:02:58 desktop kernel:  [<ffffffff81444342>] ? tun_get_user+0x3f2/=
0x8e0
Dec 12 10:02:58 desktop kernel:  [<ffffffffa01b6426>] ?
translate_desc+0x76/0x150 [vhost]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa01b70a7>] ?
vhost_get_vq_desc+0x2d7/0x630 [vhost]
Dec 12 10:02:58 desktop kernel:  [<ffffffff8144486c>] ? tun_sendmsg+0x3c/0x=
60
Dec 12 10:02:58 desktop kernel:  [<ffffffffa01c0777>] ?
handle_tx+0x207/0x490 [vhost_net]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa01b44b9>] ?
vhost_worker+0x99/0xf0 [vhost]
Dec 12 10:02:58 desktop kernel:  [<ffffffffa01b4420>] ?
vhost_dev_init+0x260/0x260 [vhost]
Dec 12 10:02:58 desktop kernel:  [<ffffffff81002536>] ? do_syscall_64+0x56/=
0x160
Dec 12 10:02:58 desktop kernel:  [<ffffffff810550bb>] ? SyS_exit_group+0xb/=
0x10
Dec 12 10:02:58 desktop kernel:  [<ffffffff8106b1c9>] ? kthread+0xb9/0xd0
Dec 12 10:02:58 desktop kernel:  [<ffffffff8106b110>] ? kthread_park+0x50/0=
x50
Dec 12 10:02:58 desktop kernel:  [<ffffffff81604ea2>] ? ret_from_fork+0x22/=
0x30
Dec 12 10:02:58 desktop kernel: ---[ end trace d8a0c3bc226461ef ]---


Thanks for your time, your work and your attention.

Kind regards,
Jes=C3=BAs Rodr=C3=ADguez Acosta

--
http://es.linkedin.com/in/jesusrodriguezacosta
(+34) 653 79 09 64

IMPORTANTE: Este mensaje de correo est=C3=A1 destinado =C3=BAnicamente a la
persona o entidad a la cual se dirige y puede contener informaci=C3=B3n
privilegiada, confidencial y/o de acceso restringido seg=C3=BAn la
legislaci=C3=B3n vigente. Si usted no es el destinatario indicado, por la
presente queda informado de que cualquier uso, distribuci=C3=B3n o copia de
la comunicaci=C3=B3n est=C3=A1 estrictamente prohibido. Si usted ha recibid=
o
esta comunicaci=C3=B3n por error, por favor, av=C3=ADseme de inmediato. Gra=
cias.

IMPORTANT: This email message is intended only for the use of the
individual to whom, or entity to which, it is addressed and may
contain information that is privileged, confidential and/or exempt
from disclosure under applicable law. If you are NOT the intended
recipient, you are hereby notified that any use, dissemination,
distribution or copying of the communication is strictly prohibited.
If you have received this communication in error, please notify me
immediately. Thank you.
