Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795231186;
	b=XVhAL7HqO2UroDyYVXgTtTPMc2+vjV2gQly/+vgWUmFHArXHgsQmS0wlY96TIhpTj0G9
	 o77ADsrVzuHpOyWavcTnW9ePkhQcUdjySJpgKfrBZEFyH9l1dqT1isXsblNPORyeOIAa7
	 iNa7zoccul4a/f2NbmpcnIRL55GAmZuNKG+wtbZqsyfWJRTnDvFB0zmJxxCaTpoFnFYge
	 5eUQH+DlOIkPYQfm/nC200maThN1XCxrstvt48stMMb+NUOFP9YlKSTENeILG1vW45s84
	 PvLNS4lrZU3gSaMDAHaHAH9MotG8xI+DyeotH9MxvdHAOmiRoQSdoU+nwtp0Dq+AWEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231186;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-exchange-messagesentrepresentingtype:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:
	 X-MS-Exchange-CrossTenant-rms-persistedconsumerorg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=eR7mF1AKl0OfkiT/fZrIxXsWa4Wpmw106QPAKSbGsiA=;
	b=x/JOu+uTMJs5jwI6Xr4Sy2r9z1l12+pDFnMIte6yYqrszrKa+/JJtZvo6ObkZR1Fnx2g
	 QoivC8WqzxyDtGrcpOpcOAjGU2KnfjDqsp7vgaIl98XMW4GMUuWD7Ze/86nRd6BukME2w
	 BRHagLhOnAt21dk+9fy+wgSBpGzhdod27TjXIr39g2ctdGIfxhkML7KVXHUWlC1wn4uAd
	 gPe6S4i71tLZtO9HJgEwdb5wkwn+TcaCLFF5OtCQzUokqsx299GXzicb03JD7HBcXFKCt
	 qliD32vymQP/fmIC9mclWogtz5u6n+KCArx5XdFeh/6k/wY/s0nfzkmqUrOP4Ix+LVw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=DtcwFXzW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.33.28
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazolkn19011028.outbound.protection.outlook.com [52.103.33.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6E3606A685
	for <cgroups@vger.kernel.org>; Sat, 21 Nov 2026 03:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD6E3606A685
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=DtcwFXzW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CUAavk7Say9aQXYIdols9ZodlymoIvRvJ64hVbVEinjngaxlmbokrvwLywd7F34LG/HPcMz62ErmjruEmPKz0ngpGD2rQXxBTbgpsCmszGDDR8miY9cnspumuWTP8lvCoRJQvMYp2uK/tC/hMgkkk6coDrg8+gYOMcc6qTTLucEPRdNxOZfMKpMdW9Q2YZblvxyasklIuGwwBaaJrajxx3WyPP9yj2vMK81axTV6DHKZn72VE2WQU+pFw99i67oWye/7iYsjj7Bj6lc1XTUj+0oHfoqpV/fWWrSjEV0Js4LkWBvKpFA/x9+9RqLLNR/1qSlqmIz/W/9c6QK2Tw9x8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eR7mF1AKl0OfkiT/fZrIxXsWa4Wpmw106QPAKSbGsiA=;
 b=p2MBN2AkpKtzgJKyFRglDzw1nmRezv1to94uT+YTaEeFoTU0rv96CltSS3yKwdpNHT4X9t2x1s65A85gzbjsqcKLpYPaULWjvx9Hy3c4+/ctdnofcCRKAGqN74ueSDPtCKaiBKwjtmPYdTodKdC0lo3dUndFnBACUUGYgf7NVINgtCPpqxUcHA6o7LEnrhcpDR64KQi7A4HRfFM3H4wsMxLTPIq49LpqzRbVEcvXUOeDSMrJ0Zmhg68v5aqhjASmLvZ2J8E6n6JHe7G3mCMlIa/z8ioV1g2DGVYY8eCVqsQmu2IhvyXhaECGJceuID2Lxtm2ftoJgI66mtly7F5RHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eR7mF1AKl0OfkiT/fZrIxXsWa4Wpmw106QPAKSbGsiA=;
 b=DtcwFXzWtxKHqmtMxk+WzFh+HT6Fy2ler5yLXhFy9/yM6vAK43CcQJ6lVNVb4z3uW7U5j4tQGuKdxM+iIQDykJBLNrKqC45NnoYQ3X7oBk/HbwkQWqUq0me2C8kMGAwMWU/B6HAqb38Fh3M1BWugaF2NBQFihqE01EOrWVYbiED25tPVdS9vPUP7qZeIeeCMMqgfGGIfCyZpGGDJXSxVqi7v/LKn94brndg2ubZVcCplV/D2s/6AIyjAHjSmnFkLNjtUltGEZa78wQq3ydzbsZ3wvD0G/GtGYkTKNrw/g2eVbKJ7++w1aV7qY7j4xtLJ2WvwRb5bX5kQQeEX+SrKxg==
Received: from AMBPR01MB11979.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:6f6::9) by AS8PR01MB7222.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:25d::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Sat, 21 Nov
 2026 03:19:42 +0000
Received: from AMBPR01MB11979.eurprd01.prod.exchangelabs.com
 ([fe80::32ad:fd3e:e613:3101]) by
 AMBPR01MB11979.eurprd01.prod.exchangelabs.com ([fe80::32ad:fd3e:e613:3101%4])
 with mapi id 15.21.0639.012; Sat, 21 Nov 2026 03:19:40 +0000
From: Espen Tveit <espen.tveit@outlook.com>
To: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Subject: cgroup.kill: forked child can survive kill (race, reproducer)
Thread-Topic: cgroup.kill: forked child can survive kill (race, reproducer)
Thread-Index: AQHdeWPbqzvXeYKE8k6LO92xwMx9UA==
Date: Sat, 21 Nov 2026 03:19:39 +0000
Message-ID:
 <AMBPR01MB119796CDE7F296E3348184D29E5472@AMBPR01MB11979.eurprd01.prod.exchangelabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AMBPR01MB11979:EE_|AS8PR01MB7222:EE_
x-ms-office365-filtering-correlation-id: 0c4918fe-aa09-437d-7f82-08df477e4758
x-microsoft-antispam:
 BCL:0;ARA:14566002|15080799012|15030799006|41001999006|24021099003|31061999003|8062599012|19110799012|8060799015|20031999006|4140399003|25010399006|39105399006|440099028|3412199025|102099032|40105399003;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?bzNXRfA0umSZxGeHjueYp5/fqrTacLtF/CEe1PzlFDoN8Ufj3JwQVAJa?=
 =?Windows-1252?Q?MAWZRKI/1IS9uj5EIbX4OVHshvGjAxO3w0rzq9cVNaGFARdR0q9al6Tx?=
 =?Windows-1252?Q?W6upMeJbYws32I9GTdQSN3G1D5lp9Nj9tnLb7glh3AaXPYzI6A09Xlxt?=
 =?Windows-1252?Q?moS7xqW+MMM058i5IvNsuS3LBxqrHBdH863npZsuCHogMppLEtnUe1Ni?=
 =?Windows-1252?Q?WbW1bJh7o7qqE6ig5gObCO2JAxQGT8co51cyOTdgvWP3nW+xS4EEc8C3?=
 =?Windows-1252?Q?3n04euQ4KYbuKNSRwxufVf8XwzvJJbGErlhnGrg0DOgX2g2CT17kY5un?=
 =?Windows-1252?Q?2BOr2K4J60YzFAAf6Z9g1Mnu4mHJsCgPO9yyEfOPaT9LzYGf/LLZMWN4?=
 =?Windows-1252?Q?w8FCR6Mca79t5Z7bqpkf5nV35q4wnUYGyrRi/32nXvrfnbrNMiQS4LIm?=
 =?Windows-1252?Q?Se5NB+3TLaAkwGUH7kfdXxmX06ftoLxAEGdmxKhJmGFaGH5X2nhV4BUo?=
 =?Windows-1252?Q?QFYwa6u3W9nGfS5Pm2pxZ/wUFneZdfcZCLzD5hk40Z7EqqkwizJZRDoY?=
 =?Windows-1252?Q?3pvPCk2vyA5fdKH7uSyBOO4v/gooSlv8mxN//ue3IxTR4exCAwpftOk1?=
 =?Windows-1252?Q?xctIxNehRsZgTwYCRATpwc2wnH0cSBm1uVRILFLpqe5tSAtsNLVj8stp?=
 =?Windows-1252?Q?3bWu9tSwFgSuZXQxYDrjLOOEcCBJHLthW0v/Iq7/3J/cGC91GCmP6mYl?=
 =?Windows-1252?Q?ALhDfBZ7XMLnYjLhvYR34P03+LnLHcjIqUer/0jAj3FHKF4FwuVQhoug?=
 =?Windows-1252?Q?5PF2mWOb2qbh1b1d6PutGhK4aNS3b/PBgL5LA49yY6q24vsKJphBMoT2?=
 =?Windows-1252?Q?BbAeh6fHes5R0qTKk14RFZUCl4C0uCnNb7UtZzPEZfwgk0EmH8uLe9fC?=
 =?Windows-1252?Q?Yttg08jEmZep8RuIWUPZUolv3X/BvJHngFLsDPk47faZ7SZtaDEZTo+P?=
 =?Windows-1252?Q?EExa2kKEdJV+7aJX5BxH7KywBvEEv3cD1763Aw1hxhui8gzyq7WdB0nP?=
 =?Windows-1252?Q?bkVwNtYgkdXPghTLU/37mFS2xKa+mlvTa19iGE6qm1xKepmnxOAnoMuf?=
 =?Windows-1252?Q?NF8=3D?=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?OiEShZwJlY6tYsp70jEW1AZqi0y/sd8fZcqUMF1qqwTwBk8QGcaBMhX5?=
 =?Windows-1252?Q?qsNyiKEaaMmFt4lDO18GcsnWH4jqD+6yHGiUC0KmTMHbaf7G7erE9WOY?=
 =?Windows-1252?Q?onKygBdAfSJrTxZeiBMOcDf9bROF+k6uuaB7XhrBDNTS8wU5R4wziF5W?=
 =?Windows-1252?Q?wBHP1xiT2oOJKao5WfsJjZcn7qH89gAkJor9DP+23phdrfcF/xKx/XzB?=
 =?Windows-1252?Q?nTD3n4ZsaUPAULM0xPsAD8wb5E0I7pVFicuw5IoWADWVUpWhgh/dsp8x?=
 =?Windows-1252?Q?IRmAasp6kjBYQqh3WCEQtv0NKeRPMq9r/1QA4rMCXzNT160fRGisnIBO?=
 =?Windows-1252?Q?6Y0VZ6IN04wD3Wv1F0Fgqza92FrfgisCmTY6uLIeZCclG9CWDeZp+TUf?=
 =?Windows-1252?Q?tCVbYbPcFC4BrTFoAJNqst0YBel6zLxqKn5Mbs3IL5/IshtdnPtnjFVk?=
 =?Windows-1252?Q?arCg03ROrfQ4mdS+IRnPWO3vgaC3H+LLbZvceN0cHV8g1vwf/ZVxlV3w?=
 =?Windows-1252?Q?XzgT/I2+iFIyWg8yeHBNQA1V9yKisBM5j3faw0lGoPWb/3MV7I8oLKiM?=
 =?Windows-1252?Q?8ByBTBrisO29CY8tbklMgmMJ1atRBlVckpG8CScN2gdQ27q8xHKmWDzG?=
 =?Windows-1252?Q?uavTrtOSo5S92UoOsCGTNV0nHMZnjbhEyjHnhankO7Sxt1zwEywnAhqx?=
 =?Windows-1252?Q?Bgyw/LizTO/1BkDSazpV1OiauYK58Y5j6VLIpSkcaB46f4iaEJ4rMJoB?=
 =?Windows-1252?Q?azS59ser7ibz5MhCm/6r3wqJLlswMU8wMfQH7CkVbN5c38XE48UMpw6D?=
 =?Windows-1252?Q?UW6YGckFiOrkpZ+3i2vzszMbd8Wr45gQiYLN442oRFdeK9GjDwVxkKh8?=
 =?Windows-1252?Q?WfXNFWGfHjloPYFWzGjTcCP6W3NQGPkogVafRA1RgRan2iluCDBZ3mUj?=
 =?Windows-1252?Q?aiZZdaVBebGRFYZvoGwSAPppTzFbGeuq1saTxx5M4hgWBDQemoYOlNsN?=
 =?Windows-1252?Q?sCLC9dhkLemHmz9HYZ7ChpKfOW1XKg+A/mSn2xOZ/XHLKKmiTKguOeCS?=
 =?Windows-1252?Q?KdYDjCyH4nT4+k0YYjVSkGmtcP3DBxHeE6RD/6LHkEM0XFYki3X3w8b7?=
 =?Windows-1252?Q?3Kw/4p3Kw2/UzgI/IVNsrueK3u2hVqzvd40/Pc42rxwHBOiDvWBHXJkV?=
 =?Windows-1252?Q?vLFQL6L3eZDYSOdDvYcKoeA8wnX8m1ysX9hAqizHqvKNvekUp1yLTCph?=
 =?Windows-1252?Q?ZFkN1JcV26t4Wd17kYc0FZO3rDtQfn9jOWUU+ZSrzbKE1MZnk7i4PgJh?=
 =?Windows-1252?Q?Je49bSBPUgWhPEqi0HRGMZJaoTwpiNANeBoExL4PkOyhiFJAgNzDCguL?=
 =?Windows-1252?Q?CC6tw912olzClMH85QiBtTXBB9qywiHMV4krj+KVliFsE+CFgp22CNB4?=
 =?Windows-1252?Q?1tNG/YXmhz6wldE5T9WYWxDFlhfbIV634/VcJG9M1nKFAK5MTv8neDjU?=
 =?Windows-1252?Q?gWnQnTL2?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AMBPR01MB11979.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c4918fe-aa09-437d-7f82-08df477e4758
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2026 03:19:39.8134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR01MB7222

Hi,=0A=
=0A=
I=92ve just found a race in cgroup.kill using a TLA+ model and reproducer w=
ritten by Opus.=0A=
=0A=
// a child forked while cgroup.kill is at work survives it.=0A=
//=0A=
//   cc -O2 -o cgkillrace cgkillrace.c=0A=
//   systemd-run --user --scope -q -p Delegate=3Dyes ./cgkillrace [trials] =
[ballast]=0A=
//=0A=
// Needs a delegated cgroup v2 directory, no privileges.=0A=
//=0A=
// The interleaving, with K the task writing cgroup.kill and F a forking ta=
sk:=0A=
//=0A=
//   K  __cgroup_kill(): kill_seq++=0A=
//   F  cgroup_can_fork(): samples kill_seq          (already the new value=
)=0A=
//   F  copy_process(): fatal_signal_pending(current)?   no=0A=
//   K  the task iteration reaches F: SIGKILL; reaches the end of the list=
=0A=
//   F  cgroup_post_fork(): links the child; kill_seq unchanged: child live=
s=0A=
//=0A=
// "ballast" processes ahead of F in the cgroup's task list give K's=0A=
// iteration the time F needs between the second and the third line.=0A=
#define _GNU_SOURCE=0A=
#include <errno.h>=0A=
#include <fcntl.h>=0A=
#include <signal.h>=0A=
#include <stdio.h>=0A=
#include <stdlib.h>=0A=
#include <string.h>=0A=
#include <sys/stat.h>=0A=
#include <sys/wait.h>=0A=
#include <time.h>=0A=
#include <unistd.h>=0A=
=0A=
static char base[512];=0A=
=0A=
static int put(const char *dir, const char *file, const char *val)=0A=
{=0A=
	char path[768];=0A=
	int fd, r;=0A=
=0A=
	snprintf(path, sizeof(path), "%s/%s/%s", base, dir, file);=0A=
	fd =3D open(path, O_WRONLY);=0A=
	if (fd < 0)=0A=
		return -1;=0A=
	r =3D write(fd, val, strlen(val));=0A=
	close(fd);=0A=
	return r < 0 ? -1 : 0;=0A=
}=0A=
=0A=
static int procs(const char *dir, char *buf, int len)=0A=
{=0A=
	char path[768];=0A=
	int fd, n;=0A=
=0A=
	snprintf(path, sizeof(path), "%s/%s/cgroup.procs", base, dir);=0A=
	fd =3D open(path, O_RDONLY);=0A=
	n =3D read(fd, buf, len - 1);=0A=
	close(fd);=0A=
	buf[n > 0 ? n : 0] =3D 0;=0A=
	return n > 0 ? n : 0;=0A=
}=0A=
=0A=
static void forker(void)=0A=
{=0A=
	struct timespec ts =3D { 0, 60 * 1000 };=0A=
	pid_t me =3D getpid();=0A=
=0A=
	signal(SIGCHLD, SIG_IGN);             // children are reaped by the kernel=
=0A=
	for (;;) {=0A=
		pid_t c =3D fork();=0A=
		if (!c) {=0A=
			// A child still here when its parent is gone outlived the=0A=
			// kill: stay, to be found in cgroup.procs.=0A=
			nanosleep(&ts, NULL);=0A=
			if (getppid() =3D=3D me)=0A=
				_exit(0);=0A=
			for (;;)=0A=
				pause();=0A=
		}=0A=
	}=0A=
}=0A=
=0A=
static void seed(int ballast, int ready)=0A=
{=0A=
	char pidbuf[32];=0A=
=0A=
	snprintf(pidbuf, sizeof(pidbuf), "%d", getpid());=0A=
	if (put("K", "cgroup.procs", pidbuf))=0A=
		_exit(1);=0A=
	for (int i =3D 0; i < ballast; i++)=0A=
		if (!fork())=0A=
			for (;;)=0A=
				pause();=0A=
	if (!fork())=0A=
		forker();=0A=
	write(ready, "r", 1);=0A=
	for (;;)=0A=
		pause();=0A=
}=0A=
=0A=
int main(int argc, char **argv)=0A=
{=0A=
	int trials =3D argc > 1 ? atoi(argv[1]) : 2000;=0A=
	int ballast =3D argc > 2 ? atoi(argv[2]) : 150;=0A=
	char path[768], line[512], pidbuf[32], buf[4096];=0A=
	long escapes =3D 0, escaped_trials =3D 0;=0A=
	FILE *f;=0A=
=0A=
	f =3D fopen("/proc/self/cgroup", "r");=0A=
	if (!f || !fgets(line, sizeof(line), f) || strncmp(line, "0::", 3)) {=0A=
		fprintf(stderr, "no cgroup v2\n");=0A=
		return 1;=0A=
	}=0A=
	fclose(f);=0A=
	line[strcspn(line, "\n")] =3D 0;=0A=
	snprintf(base, sizeof(base), "/sys/fs/cgroup%s", line + 3);=0A=
	snprintf(path, sizeof(path), "%s/main", base);=0A=
	mkdir(path, 0755);=0A=
	snprintf(pidbuf, sizeof(pidbuf), "%d", getpid());=0A=
	if (put("main", "cgroup.procs", pidbuf)) {=0A=
		perror("move to main");=0A=
		return 1;=0A=
	}=0A=
	snprintf(path, sizeof(path), "%s/K", base);=0A=
	mkdir(path, 0755);=0A=
	srand(getpid());=0A=
=0A=
	for (int t =3D 0; t < trials; t++) {=0A=
		int pfd[2], n;=0A=
		pid_t s;=0A=
		char c;=0A=
=0A=
		pipe(pfd);=0A=
		s =3D fork();=0A=
		if (!s)=0A=
			seed(ballast, pfd[1]);=0A=
		close(pfd[1]);=0A=
		read(pfd[0], &c, 1);=0A=
		close(pfd[0]);=0A=
		usleep(500 + rand() % 2000);=0A=
=0A=
		put("K", "cgroup.kill", "1");=0A=
		waitpid(s, NULL, 0);=0A=
		usleep(5000);                         // let the dying die=0A=
		n =3D procs("K", buf, sizeof(buf));=0A=
		if (n) {=0A=
			// not merely slow to die: still there 300 ms later=0A=
			usleep(300000);=0A=
			n =3D procs("K", buf, sizeof(buf));=0A=
		}=0A=
		if (n) {=0A=
			int cnt =3D 0;=0A=
			for (char *p =3D buf; *p; p++)=0A=
				cnt +=3D *p =3D=3D '\n';=0A=
			escapes +=3D cnt;=0A=
			escaped_trials++;=0A=
			if (escaped_trials <=3D 3) {=0A=
				char sp[64], sb[512] =3D "", st =3D '?';=0A=
				int fd, ppid =3D 0;=0A=
=0A=
				buf[strcspn(buf, "\n")] =3D 0;=0A=
				snprintf(sp, sizeof(sp), "/proc/%s/stat", buf);=0A=
				fd =3D open(sp, O_RDONLY);=0A=
				if (fd >=3D 0) {=0A=
					int k =3D read(fd, sb, sizeof(sb) - 1);=0A=
					char *q;=0A=
					close(fd);=0A=
					sb[k > 0 ? k : 0] =3D 0;=0A=
					q =3D strrchr(sb, ')');=0A=
					if (q)=0A=
						sscanf(q + 2, "%c %d", &st, &ppid);=0A=
				}=0A=
				printf("trial %d: %d process(es) alive in the cgroup 300 ms after cgrou=
p.kill: "=0A=
				       "pid %s, state %c, parent %d (the forker is dead)\n",=0A=
				       t, cnt, buf, st, ppid);=0A=
				fflush(stdout);=0A=
			}=0A=
			while (procs("K", buf, sizeof(buf))) {  // clean up for the next trial=
=0A=
				put("K", "cgroup.kill", "1");=0A=
				usleep(2000);=0A=
			}=0A=
		}=0A=
	}=0A=
	printf("%d trials, %d ballast: cgroup.kill left survivors in %ld trials (%=
ld processes)\n",=0A=
	       trials, ballast, escaped_trials, escapes);=0A=
	snprintf(pidbuf, sizeof(pidbuf), "%d", getpid());=0A=
	put("", "cgroup.procs", pidbuf);=0A=
	snprintf(path, sizeof(path), "%s/K", base);=0A=
	rmdir(path);=0A=
	snprintf(path, sizeof(path), "%s/main", base);=0A=
	rmdir(path);=0A=
	return 0;=0A=
}=0A=
=0A=
-=0A=
Espen Tveit=
