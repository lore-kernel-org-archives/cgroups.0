From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Thu, 11 May 2023 09:23:50 -0700
Message-ID: <CALvZod7Y+SxiopRBXOf1HoDKO=Xh8CNPfgz3Etd4XOq5BPc5Ag@mail.gmail.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com> <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683822242; x=1686414242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XB+NFYBcznFooDN9O0xTNgaLjM4RUCXNttuSZwxlS94=;
        b=VTb18c/6+iJuVDVsNI1M/SqfD5jiDm60zxPGBzJOSf/UvuUnJiHFM3aNLflAMCOG/M
         gyRRuU++w5cV3LOE36hexMFH6NQXlRscSX4T0svjYDh2tzlqA5bMycbUOrtm2Nd5cwu5
         HJ816jt33I57CiwU4WZuLqtdyXzOQ6BH9gG/rFt/u+dyK5krjkoimIrGDVbJgpAcTJ4a
         xVaeixXqkpl0y+0kVyGtwg2WU3jWlyq/Lq1NvMYGc2+Q0rQ7Ur2KmRIqBaYtypvEfsfy
         KarovuSrmCsLU5sP2lItzMMyn+xLLxkTq9uzoSz14yBsABOZvv+lg2Knvs3zz8BXoqRE
         jdcA==
In-Reply-To: <IA0PR11MB73557DEAB912737FD61D2873FC749-py0Qfd72Ncwkr2bXB6wcV5PPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 11, 2023 at 2:27=E2=80=AFAM Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
>
>
>
[...]
>
> Here is the output with the command you paste, it's from system wide,
> I only show pieces of memcached records, and it seems to be a
> callee -> caller stack trace:
>
>      9.02%  mc-worker        [kernel.vmlinux]          [k] page_counter_t=
ry_charge
>             |
>              --9.00%--page_counter_try_charge
>                        |
>                         --9.00%--try_charge_memcg
>                                   mem_cgroup_charge_skmem
>                                   |
>                                    --9.00%--__sk_mem_raise_allocated
>                                              __sk_mem_schedule
>                                              |
>                                              |--5.32%--tcp_try_rmem_sched=
ule
>                                              |          tcp_data_queue
>                                              |          tcp_rcv_establish=
ed
>                                              |          tcp_v4_do_rcv
>                                              |          tcp_v4_rcv
>                                              |          ip_protocol_deliv=
er_rcu
>                                              |          ip_local_deliver_=
finish
>                                              |          ip_local_deliver
>                                              |          ip_rcv
>                                              |          __netif_receive_s=
kb_one_core
>                                              |          __netif_receive_s=
kb
>                                              |          process_backlog
>                                              |          __napi_poll
>                                              |          net_rx_action
>                                              |          __do_softirq
>                                              |          |
>                                              |           --5.32%--do_soft=
irq.part.0
>                                              |                     __loca=
l_bh_enable_ip
>                                              |                     __dev_=
queue_xmit
>                                              |                     ip_fin=
ish_output2
>                                              |                     __ip_f=
inish_output
>                                              |                     ip_fin=
ish_output
>                                              |                     ip_out=
put
>                                              |                     ip_loc=
al_out
>                                              |                     __ip_q=
ueue_xmit
>                                              |                     ip_que=
ue_xmit
>                                              |                     __tcp_=
transmit_skb
>                                              |                     tcp_wr=
ite_xmit
>                                              |                     __tcp_=
push_pending_frames
>                                              |                     tcp_pu=
sh
>                                              |                     tcp_se=
ndmsg_locked
>                                              |                     tcp_se=
ndmsg
>                                              |                     inet_s=
endmsg
>                                              |                     sock_s=
endmsg
>                                              |                     ____sy=
s_sendmsg
>
>      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter_c=
ancel
>             |
>              --8.97%--page_counter_cancel
>                        |
>                         --8.97%--page_counter_uncharge
>                                   drain_stock
>                                   __refill_stock
>                                   refill_stock
>                                   |
>                                    --8.91%--try_charge_memcg
>                                              mem_cgroup_charge_skmem
>                                              |
>                                               --8.91%--__sk_mem_raise_all=
ocated
>                                                         __sk_mem_schedule
>                                                         |
>                                                         |--5.41%--tcp_try=
_rmem_schedule
>                                                         |          tcp_da=
ta_queue
>                                                         |          tcp_rc=
v_established
>                                                         |          tcp_v4=
_do_rcv
>                                                         |          tcp_v4=
_rcv
>                                                         |          ip_pro=
tocol_deliver_rcu
>                                                         |          ip_loc=
al_deliver_finish
>                                                         |          ip_loc=
al_deliver
>                                                         |          ip_rcv
>                                                         |          __neti=
f_receive_skb_one_core
>                                                         |          __neti=
f_receive_skb
>                                                         |          proces=
s_backlog
>                                                         |          __napi=
_poll
>                                                         |          net_rx=
_action
>                                                         |          __do_s=
oftirq
>                                                         |          do_sof=
tirq.part.0
>                                                         |          __loca=
l_bh_enable_ip
>                                                         |          __dev_=
queue_xmit
>                                                         |          ip_fin=
ish_output2
>                                                         |          __ip_f=
inish_output
>                                                         |          ip_fin=
ish_output
>                                                         |          ip_out=
put
>                                                         |          ip_loc=
al_out
>                                                         |          __ip_q=
ueue_xmit
>                                                         |          ip_que=
ue_xmit
>                                                         |          __tcp_=
transmit_skb
>                                                         |          tcp_wr=
ite_xmit
>                                                         |          __tcp_=
push_pending_frames
>                                                         |          tcp_pu=
sh
>                                                         |          tcp_se=
ndmsg_locked
>                                                         |          tcp_se=
ndmsg
>                                                         |          inet_s=
endmsg
>
>      8.78%  mc-worker        [kernel.vmlinux]          [k] try_charge_mem=
cg
>             |
>              --8.77%--try_charge_memcg
>                        |
>                         --8.76%--mem_cgroup_charge_skmem
>                                   |
>                                    --8.76%--__sk_mem_raise_allocated
>                                              __sk_mem_schedule
>                                              |
>                                              |--5.21%--tcp_try_rmem_sched=
ule
>                                              |          tcp_data_queue
>                                              |          tcp_rcv_establish=
ed
>                                              |          tcp_v4_do_rcv
>                                              |          |
>                                              |           --5.21%--tcp_v4_=
rcv
>                                              |                     ip_pro=
tocol_deliver_rcu
>                                              |                     ip_loc=
al_deliver_finish
>                                              |                     ip_loc=
al_deliver
>                                              |                     ip_rcv
>                                              |                     __neti=
f_receive_skb_one_core
>                                              |                     __neti=
f_receive_skb
>                                              |                     proces=
s_backlog
>                                              |                     __napi=
_poll
>                                              |                     net_rx=
_action
>                                              |                     __do_s=
oftirq
>                                              |                     |
>                                              |                      --5.2=
1%--do_softirq.part.0
>                                              |                           =
     __local_bh_enable_ip
>                                              |                           =
     __dev_queue_xmit
>                                              |                           =
     ip_finish_output2
>                                              |                           =
     __ip_finish_output
>                                              |                           =
     ip_finish_output
>                                              |                           =
     ip_output
>                                              |                           =
     ip_local_out
>                                              |                           =
     __ip_queue_xmit
>                                              |                           =
     ip_queue_xmit
>                                              |                           =
     __tcp_transmit_skb
>                                              |                           =
     tcp_write_xmit
>                                              |                           =
     __tcp_push_pending_frames
>                                              |                           =
     tcp_push
>                                              |                           =
     tcp_sendmsg_locked
>                                              |                           =
     tcp_sendmsg
>                                              |                           =
     inet_sendmsg
>                                              |                           =
     sock_sendmsg
>                                              |                           =
     ____sys_sendmsg
>                                              |                           =
     ___sys_sendmsg
>                                              |                           =
     __sys_sendmsg
>
>
> >


I am suspecting we are doing a lot of charging for a specific memcg on
one CPU (or a set of CPUs) and a lot of uncharging on the different
CPU (or a different set of CPUs) and thus both of these code paths are
hitting the slow path a lot.

Eric, I remember we have an optimization in the networking stack that
tries to free the memory on the same CPU where the allocation
happened. Is that optimization enabled for this code path? Or maybe we
should do something similar in memcg code (with the assumption that my
suspicion is correct).
