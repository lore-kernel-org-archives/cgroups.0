From: Jean-Tiare LE BIGOT <jean-tiare.le-bigot-SavXxUIaH7I@public.gmane.org>
Subject: using cgroups' classif with iptables
Date: Thu, 20 Mar 2014 18:28:15 +0100
Message-ID: <532B252F.80302@ovh.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

In https://www.kernel.org/doc/Documentation/cgroups/net_cls.txt there is 
a example to match the classid, set with a cgroup, with iptables:
	iptables -A OUTPUT -m cgroup ! --cgroup 0x100001 -j DROP

However, I've not been able to find the corresponding kernel module 
neither the iptables side module...

Do you have any hint where I could find it ?

Thanks,

-- 
Jean-Tiare, shared-hosting team
