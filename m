From: Nicholas Krause <xerofoify@gmail.com>
Subject: Re: [PATCH] mm:Make the function alloc_mem_cgroup_per_zone_info bool
Date: Mon, 29 Jun 2015 11:23:08 -0400
Message-ID: <3320C010-248A-4296-A5E4-30D9E7B3E611@gmail.com>
References: <1435587233-27976-1-git-send-email-xerofoify@gmail.com> <20150629150311.GC4612@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=disposition-notification-to:return-receipt-to:user-agent
         :in-reply-to:references:mime-version:content-transfer-encoding
         :content-type:subject:from:date:to:cc:message-id;
        bh=FG+eY17ZWycNpXwD45ZOuKCoyO2Nj4HV9jyQmJ4EjV0=;
        b=Wu7roWKkB8wcxPNBln4tf/TqKfXMSv4CMSZ9ggXkhPIiQsL8bycRxeENY8S0HO54zG
         AalVs+YuoQ3QEa5wsJNfVXDd1PzROk+TcDXxY2PoazdNO+2qMU87Hd5m5DGAuI7Z7ABI
         ThUXpXrGvmTSh/as79USf9QfM957r4ycYZzoD/RiUuEbwxeDyduugcAS/W5e8iuZOV6u
         O78qnn/D3ERMmNDPKY1PDHPV8xQI/4OdsjZ5MdBAn9W4Ju3Uwn4uZRCR3SnMEbQ3S3EB
         outnXGTdAQEsbDpkNdMBGUs8VFQE1Q0rmbO2smJvgXoBo60L85mTl3Se3sdAS6PFHueg
         aeLw==
In-Reply-To: <20150629150311.GC4612@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



On June 29, 2015 11:03:11 AM EDT, Michal Hocko <mhocko@suse.cz> wrote:
>On Mon 29-06-15 10:13:53, Nicholas Krause wrote:
>[...]
>> -static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg,
>int node)
>> +static bool alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg,
>int node)
>>  {
>>  	struct mem_cgroup_per_node *pn;
>>  	struct mem_cgroup_per_zone *mz;
>> @@ -4442,7 +4442,7 @@ static int
>alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>>  		tmp =3D -1;
>>  	pn =3D kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
>>  	if (!pn)
>> -		return 1;
>> +		return true;
>
>Have you tried to think about the semantic of the function? The
>function
>has returned 0 to signal the success which is pretty common. It could
>have
>returned -ENOMEM for the allocation failure which would be much more
>nicer than 1.
>
>After your change we have bool semantic where the success is reported
>by
>false while failure is true. Doest this make any sense to you? Because
>it doesn't make to me and it only shows that this is a mechanical
>conversion without deeper thinking about consequences.
>
>Nacked-by: Michal Hocko <mhocko@suse.cz>
>
>Btw. I can see your other patches which trying to do similar. I would
>strongly discourage you from this path. Try to understand the code and
>focus on changes which would actually make any improvements to the code
>base. Doing stylist changes which do not help readability and neither
>help compiler to generate a better code is simply waste of your and
>reviewers time.
>
>>  	for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
>>  		mz =3D &pn->zoneinfo[zone];
>> @@ -4452,7 +4452,7 @@ static int
>alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
>>  		mz->memcg =3D memcg;
>>  	}
>>  	memcg->nodeinfo[node] =3D pn;
>> -	return 0;
>> +	return false;
>>  }
>> =20
>>  static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg,
>int node)
>> --=20
>> 2.1.4
>>=20
I agree with and looked into the callers about this wasn't sure if you yo=
u wanted me to return - ENOMEM.  I will rewrite this patch the other way.=
  Furthermore I apologize about this and do have actual useful patches bu=
t will my rep it's hard to get replies from maintainers. If you would lik=
e to take a look at them please let know.=20
Nick=20
--=20
Sent from my Android device with K-9 Mail. Please excuse my brevity.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
