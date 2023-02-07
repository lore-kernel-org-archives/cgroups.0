From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Using cgroup membership for resource access control?
Date: Tue, 7 Feb 2023 00:48:16 +0000
Message-ID: <SJ1PR11MB6083BE9581BA00F3B9833C8FFCDB9@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <Y+FvQbfTdcTe9GVu@agluck-desk3.sc.intel.com>
 <Y+F0NA9iI0zlONz7@slm.duckdns.org> <Y+F0mXS9z0flDhf7@slm.duckdns.org>
 <SJ1PR11MB6083C61BCA70A31F8C0F12ECFCDA9@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <Y+GNp4VA1T9pV6nM@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675730911; x=1707266911;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xzpFg09Ej6GAiCD9RljIocNF+osY2wLKZY5C2xh0/Es=;
  b=OdvNrxy1cRUkCEzdJALr6Y7faM8gPp3Y57LoRpFR8NGYbVNwuXFqHpIv
   MhTmcNMQTO5Wg4SLb/HldGzuyduj7lU/HvahwoNDijHAXeLYq8SLOkMpE
   TkfcM6wI3JfZfNz/Td+mfSkfypbNcswQP2UqPX6TuwVhX3b/YJ+/+FjO2
   NGpQP1t5pufuW0DhU1S+4fYiW4hlyeTq+HB0iwI1YvmjEMuSOJCwyzHtT
   RdCl5zM2n9ds13/bXJEDHg1fMCETNvIC4JBwhf1lOpbr17+A7uWYADhW7
   6QBcSDn0kXQNm5mFWaJJro6QZ/KZUcuHShIMEw5JbiiZK+M3ReRIfr1Z3
   A==;
In-Reply-To: <Y+GNp4VA1T9pV6nM-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Thomas, Ramesh" <ramesh.thomas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

> I'm not sure it'd be a good idea to introduce a whole new mode of access
> control for this when it's something which can be addressed with more
> conventional mechanisms. Maybe it's a bit more upfront work but one-off
> security / naming mechanism feels like they'd have a reasonable chance to
> cause long term headaches.

Being the first to do something is always risky. But thanks for looking at =
my ideas.
I'm going to take your advice and try to build on existing mechanisms inste=
ad
of creating a new thing.

-Tony
